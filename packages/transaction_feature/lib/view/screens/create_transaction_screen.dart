import 'package:auto_size_text/auto_size_text.dart';
import 'package:category_feature/data/category_data.dart';
import 'package:category_feature/view/categories_modal_sheet.dart';
import 'package:core/services/modal_sheet_service.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';
import 'package:transaction_feature/view/components/create_transaction_icon_button.dart';
import 'package:transaction_feature/view/components/transaction_keyboard.dart';
import 'package:transaction_feature/view/components/voice_recognition_icon_button.dart';
import 'package:voice_recognition_feature/bloc/voice_recognition_bloc.dart';
import 'package:voice_recognition_feature/view/components/voice_recognition_bloc_provider.dart';

final class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  State<CreateTransactionScreen> createState() => _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _categoryController = TextEditingController();
  final _merchantController = TextEditingController();
  final _notesController = TextEditingController();

  final _amountNotifier = ValueNotifier('0');
  CategoryData? _selectedCategory;

  @override
  void dispose() {
    _amountNotifier.dispose();
    _categoryController.dispose();
    _merchantController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionBlocState>(
      listener: (context, state) {
        if (state is CreatedTransactionBlocState) {
          Navigator.of(context).pop(true);
        } else if (state is ErrorCreateTransactionBlocState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: DismissKeyboard(
        child: VoiceRecognitionBlocProvider(
          child: Scaffold(
            floatingActionButtonLocation: .centerDocked,
            floatingActionButton: Row(
              spacing: 24,
              mainAxisAlignment: .center,
              children: [
                BlocConsumer<VoiceRecognitionBloc, VoiceRecognitionBlocState>(
                  listener: (context, state) {
                    if (state is ErrorVoiceRecognitionBlocState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message ?? 'Unexpected error'),
                        ),
                      );
                    }
                  },
                  builder: (context, state) => VoiceRecognitionIconButton(
                    onPressed: () {
                      final bloc = context.read<VoiceRecognitionBloc>();

                      state.data.isListening
                          ? bloc.add(const VoiceRecognitionBlocEvent.stopListening())
                          : bloc.add(const VoiceRecognitionBlocEvent.startListening());
                    },
                    isListening: state.data.isListening,
                  ),
                ),
                CreateTransactionIconButton(onPressed: _createTransaction),
              ],
            ),
            appBar: AppBar(
              title: const Text('Finance'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 120,
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Amount',
                      style: TextTheme.of(context).titleSmall,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$',
                            style: TextTheme.of(context).displaySmall?.copyWith(
                              fontSize: 36,
                              color: ColorScheme.of(context).primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _amountNotifier,
                              builder: (context, amount, child) => AutoSizeText(
                                amount,
                                maxLines: 1,
                                minFontSize: 24,
                                stepGranularity: 1,
                                textAlign: TextAlign.center,
                                style: TextTheme.of(context).displayLarge?.copyWith(fontSize: 60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TransactionKeyboard(
                      onKeyPressed: _addAmount,
                      onPointPressed: _onPointPressed,
                      onRemovePressed: _onRemovePressed,
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: const .all(.circular(24)),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorScheme.of(context).surfaceContainer,
                        ),
                        child: Column(
                          children: [
                            _OptionListButton(
                              icon: _selectedCategory?.icon ?? Icons.grid_view_outlined,
                              title: 'Category',
                              value: _selectedCategory?.name,
                              iconColor: _selectedCategory?.color,
                              onPressed: _showCategoriesModal,
                            ),
                            const Divider(height: 1, indent: 20, endIndent: 20),
                            _OptionTextField(
                              icon: Icons.storefront_outlined,
                              hintText: 'Merchant Name',
                              controller: _merchantController,
                            ),
                            const Divider(height: 1, indent: 20, endIndent: 20),
                            _OptionTextField(
                              icon: Icons.notes_outlined,
                              hintText: 'Notes...',
                              controller: _notesController,
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addAmount(final int number) {
    final value = _amountNotifier.value;
    final pointIndex = value.indexOf('.');

    if (pointIndex != -1) {
      final fractionLength = value.length - pointIndex - 1;

      if (fractionLength >= 2) {
        return;
      }

      _amountNotifier.value = '$value$number';
      return;
    }

    if (value == '0') {
      _amountNotifier.value = '$number';
      return;
    }

    _amountNotifier.value = '$value$number';
  }

  void _onPointPressed() {
    if (_amountNotifier.value.contains('.')) {
      return;
    }

    _amountNotifier.value = '${_amountNotifier.value}.';
  }

  void _onRemovePressed() {
    final value = _amountNotifier.value;

    if (value.length <= 1) {
      _amountNotifier.value = '0';
      return;
    }

    final nextValue = value.substring(0, value.length - 1);

    _amountNotifier.value = nextValue == '-' || nextValue.isEmpty ? '0' : nextValue;
  }

  void _showCategoriesModal() {
    const ModalSheetService().showModalSheet(
      context: context,
      content: CategoriesModalSheet(onSelect: _onCategorySelected),
    );
  }

  void _onCategorySelected(final CategoryData category) {
    setState(() {
      _selectedCategory = category;
      _categoryController.text = category.id;
    });
  }

  void _createTransaction() {
    final merchant = _merchantController.text.trim();
    final notes = _notesController.text.trim();
    final selectedCategory = _selectedCategory;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a category')),
      );
      return;
    }

    context.read<TransactionBloc>().add(
      TransactionBlocEvent.create(
        title: merchant.isNotEmpty ? merchant : selectedCategory.name,
        amount: _amountNotifier.value,
        categoryId: selectedCategory.id,
        merchant: merchant.isEmpty ? null : merchant,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }
}

final class _OptionListButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color? iconColor;
  final VoidCallback onPressed;

  const _OptionListButton({
    required this.icon,
    required this.title,
    this.value,
    this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              spacing: 12,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? ColorScheme.of(context).primary,
                ),
                Expanded(
                  child: Text(
                    value ?? title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextTheme.of(context).titleSmall?.copyWith(
                      color: value == null ? null : ColorScheme.of(context).onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ColorScheme.of(context).onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _OptionTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;

  const _OptionTextField({
    required this.icon,
    required this.hintText,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        spacing: 12,
        crossAxisAlignment: maxLines == 1 ? .center : .start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines == 1 ? 0 : 14),
            child: Icon(
              icon,
              color: colorScheme.primary,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: minLines,
              maxLines: maxLines,
              textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
              decoration: InputDecoration(
                hintText: hintText,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextTheme.of(context).titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
