import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';
import 'package:merchant_feature/view/merchant_icon.dart';

final class MerchantIconPicker extends StatefulWidget {
  final String? selectedIconId;
  final ValueChanged<String?> onChanged;

  const MerchantIconPicker({
    super.key,
    required this.selectedIconId,
    required this.onChanged,
  });

  @override
  State<MerchantIconPicker> createState() => _MerchantIconPickerState();
}

final class _MerchantIconPickerState extends State<MerchantIconPicker> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _results = const [];
  int _requestId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MerchantIconRepository>();
    final selectedIconId = widget.selectedIconId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand icon', style: TextTheme.of(context).titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search brand icons',
            prefixIcon: Icon(Icons.search_rounded),
            isDense: true,
          ),
        ),
        if (selectedIconId != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              MerchantIcon(
                iconId: selectedIconId,
                repository: repository,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _labelFor(selectedIconId),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Clear icon',
                onPressed: () => widget.onChanged(null),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final iconId in _results)
                ChoiceChip(
                  selected: iconId == selectedIconId,
                  onSelected: (selected) => widget.onChanged(selected ? iconId : null),
                  avatar: MerchantIcon(
                    iconId: iconId,
                    repository: repository,
                    size: 20,
                  ),
                  label: Text(_labelFor(iconId)),
                ),
            ],
          ),
        ],
      ],
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      _requestId++;
      setState(() => _results = const []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    final requestId = ++_requestId;
    try {
      final results = await context.read<MerchantIconRepository>().search(query);
      if (!mounted || requestId != _requestId) {
        return;
      }
      setState(() => _results = List.unmodifiable(results));
    } catch (_) {
      if (!mounted || requestId != _requestId) {
        return;
      }
      setState(() => _results = const []);
    }
  }

  String _labelFor(String iconId) {
    final separator = iconId.indexOf(':');
    return separator == -1 ? iconId : iconId.substring(separator + 1);
  }
}
