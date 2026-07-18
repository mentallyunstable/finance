import 'dart:async';

import 'package:core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_feature/bloc/merchant_bloc.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';
import 'package:merchant_feature/domain/merchant_search.dart';
import 'package:merchant_feature/view/merchant_icon.dart';

final class MerchantField extends StatefulWidget {
  final TextEditingController controller;
  final Key? textFieldKey;
  final ValueChanged<MerchantData?> onChanged;
  final Future<MerchantData?> Function(String name) onAddRequested;

  const MerchantField({
    super.key,
    required this.controller,
    this.textFieldKey,
    required this.onChanged,
    required this.onAddRequested,
  });

  @override
  MerchantFieldState createState() => MerchantFieldState();
}

final class MerchantFieldState extends State<MerchantField> {
  final _focusNode = FocusNode();
  final _toastService = ToastService();
  late final TextEditingController _autocompleteController;
  Timer? _toastTimer;
  MerchantData? _selectedMerchant;
  bool _isToastVisible = false;
  bool _isAdding = false;
  bool _isUpdatingInternalController = false;
  bool _isUpdatingExternalController = false;
  bool _isRefreshingOptions = false;
  int _selectionCheckRevision = 0;

  @override
  void initState() {
    super.initState();
    _autocompleteController = TextEditingController.fromValue(
      widget.controller.value,
    );
    _autocompleteController.addListener(_onAutocompleteControllerChanged);
    _focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onExternalControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MerchantField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onExternalControllerChanged);
      widget.controller.addListener(_onExternalControllerChanged);
      _onExternalControllerChanged();
    }
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _isAdding = true;
    if (_isToastVisible) {
      _isToastVisible = false;
      _toastService.fToast.removeCustomToast();
    }
    widget.controller.removeListener(_onExternalControllerChanged);
    _autocompleteController.removeListener(
      _onAutocompleteControllerChanged,
    );
    _autocompleteController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<MerchantData>(
          textEditingController: _autocompleteController,
          focusNode: _focusNode,
          displayStringForOption: (merchant) => merchant.name,
          optionsBuilder: (value) {
            return searchMerchants(
              context.read<MerchantBloc>().state.data.merchants,
              value.text,
              limit: 5,
            );
          },
          onSelected: _selectSuggestedMerchant,
          fieldViewBuilder: (context, controller, focusNode, _) {
            return TextField(
              key: widget.textFieldKey,
              controller: controller,
              focusNode: focusNode,
              onChanged: _onTextEdited,
              onSubmitted: _submit,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Merchant Name',
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextTheme.of(context).titleSmall,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final merchants = options.take(5).toList(growable: false);
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: merchants.length * 56.0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemExtent: 56,
                    itemCount: merchants.length,
                    itemBuilder: (context, index) {
                      final merchant = merchants[index];
                      final isHighlighted = AutocompleteHighlightedOption.of(context) == index;
                      return ColoredBox(
                        color: isHighlighted ? ColorScheme.of(context).secondaryContainer : Colors.transparent,
                        child: InkWell(
                          onTap: () => onSelected(merchant),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                MerchantIcon(
                                  iconId: merchant.iconId,
                                  repository: context.read<MerchantIconRepository>(),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    merchant.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void suggestAdd() {
    final name = _autocompleteController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final exactMerchant = _findExactMerchant(name);
    if (exactMerchant != null) {
      _selectMerchant(exactMerchant);
      return;
    }

    if (_isToastVisible || _isAdding) {
      return;
    }

    _isToastVisible = true;
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(seconds: 3), () => _isToastVisible = false);

    final colorScheme = ColorScheme.of(context);
    final width = (MediaQuery.sizeOf(context).width - 48).clamp(0.0, 360.0);
    _toastService.showToast(
      context: context,
      color: colorScheme.inverseSurface,
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '"$name" is not indexed.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.onInverseSurface),
              ),
            ),
            TextButton(
              onPressed: _isAdding
                  ? null
                  : () {
                      _dismissToast();
                      unawaited(_requestAdd(name));
                    },
              style: TextButton.styleFrom(foregroundColor: colorScheme.primaryContainer),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _onTextEdited(String value) {
    final selectedMerchant = _selectedMerchant;
    if (selectedMerchant != null && value != selectedMerchant.name) {
      _selectionCheckRevision += 1;
      _selectedMerchant = null;
      widget.onChanged(null);
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus || _autocompleteController.text.isNotEmpty) {
      return;
    }

    final value = _autocompleteController.value;
    // RawAutocomplete recomputes options only after a controller text change.
    _isRefreshingOptions = true;
    try {
      _autocompleteController.value = const TextEditingValue(
        text: ' ',
        selection: TextSelection.collapsed(offset: 1),
      );
      _autocompleteController.value = value;
    } finally {
      _isRefreshingOptions = false;
    }
  }

  void _onAutocompleteControllerChanged() {
    if (_isUpdatingInternalController || _isRefreshingOptions) {
      return;
    }

    _setExternalControllerValue(_autocompleteController.value);
  }

  void _onExternalControllerChanged() {
    if (_isUpdatingExternalController) {
      return;
    }

    _setAutocompleteControllerValue(widget.controller.value);

    final selectedMerchant = _selectedMerchant;
    if (selectedMerchant == null || widget.controller.text == selectedMerchant.name) {
      return;
    }

    final revision = ++_selectionCheckRevision;
    scheduleMicrotask(() {
      if (!mounted ||
          revision != _selectionCheckRevision ||
          !identical(_selectedMerchant, selectedMerchant) ||
          widget.controller.text == selectedMerchant.name) {
        return;
      }
      _selectedMerchant = null;
      widget.onChanged(null);
    });
  }

  void _submit(String value) {
    final name = value.trim();
    if (name.isEmpty) {
      return;
    }

    final exactMerchant = _findExactMerchant(name);
    if (exactMerchant != null) {
      if (_selectedMerchant?.slug != exactMerchant.slug) {
        _selectMerchant(exactMerchant);
      }
      return;
    }

    suggestAdd();
  }

  MerchantData? _findExactMerchant(String name) {
    final normalizedName = normalizeMerchantText(name);
    for (final merchant in context.read<MerchantBloc>().state.data.merchants) {
      if (normalizeMerchantText(merchant.name) == normalizedName) {
        return merchant;
      }
    }
    return null;
  }

  void _selectSuggestedMerchant(MerchantData merchant) {
    _selectMerchant(merchant);
    _focusNode.unfocus();
  }

  void _selectMerchant(MerchantData merchant) {
    _selectionCheckRevision += 1;
    _selectedMerchant = merchant;
    final value = TextEditingValue(
      text: merchant.name,
      selection: TextSelection.collapsed(offset: merchant.name.length),
    );
    _setAutocompleteControllerValue(value);
    _setExternalControllerValue(value);
    widget.onChanged(merchant);
  }

  void _setAutocompleteControllerValue(TextEditingValue value) {
    if (_autocompleteController.value == value) {
      return;
    }

    _isUpdatingInternalController = true;
    try {
      _autocompleteController.value = value;
    } finally {
      _isUpdatingInternalController = false;
    }
  }

  void _setExternalControllerValue(TextEditingValue value) {
    if (widget.controller.value == value) {
      return;
    }

    _isUpdatingExternalController = true;
    try {
      widget.controller.value = value;
    } finally {
      _isUpdatingExternalController = false;
    }
  }

  Future<void> _requestAdd(String name) async {
    if (_isAdding) {
      return;
    }
    _isAdding = true;
    try {
      final merchant = await widget.onAddRequested(name);
      if (!mounted || merchant == null) {
        return;
      }
      _selectMerchant(merchant);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Could not add merchant. Try again.')),
      );
    } finally {
      if (mounted) {
        _isAdding = false;
      }
    }
  }

  void _dismissToast() {
    _toastTimer?.cancel();
    _isToastVisible = false;
    _toastService.fToast.removeCustomToast();
  }
}
