import 'package:category_feature/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merchant_feature/bloc/merchant_bloc.dart';
import 'package:merchant_feature/data/merchant_data.dart';
import 'package:merchant_feature/view/merchant_icon_picker.dart';

final class AddMerchantScreen extends StatefulWidget {
  final String initialName;

  const AddMerchantScreen({super.key, this.initialName = ''});

  @override
  State<AddMerchantScreen> createState() => _AddMerchantScreenState();
}

final class _AddMerchantScreenState extends State<AddMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _descriptionController = TextEditingController();
  final Set<String> _selectedCategoryIds = {};
  String? _selectedIconId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MerchantBloc, MerchantBlocState>(
      listener: _onMerchantState,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add merchant'),
          actions: [
            IconButton(
              tooltip: 'Save merchant',
              onPressed: _save,
              icon: const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: widget.initialName.isEmpty,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Merchant name',
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Merchant name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 20),
              MerchantIconPicker(
                selectedIconId: _selectedIconId,
                onChanged: (iconId) => setState(() => _selectedIconId = iconId),
              ),
              const SizedBox(height: 20),
              Text('Categories', style: TextTheme.of(context).titleSmall),
              const SizedBox(height: 8),
              BlocBuilder<CategoryBloc, CategoryBlocState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in state.data.categories)
                        FilterChip(
                          selected: _selectedCategoryIds.contains(category.id),
                          avatar: Icon(category.icon, color: category.color, size: 18),
                          label: Text(category.name),
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? _selectedCategoryIds.add(category.id)
                                  : _selectedCategoryIds.remove(category.id);
                            });
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    context.read<MerchantBloc>().add(
      MerchantBlocEvent.create(
        name: _nameController.text,
        description: _descriptionController.text,
        iconId: _selectedIconId,
        categoryIds: _selectedCategoryIds.toList(growable: false),
      ),
    );
  }

  void _onMerchantState(BuildContext context, MerchantBlocState state) {
    if (state is CreatedMerchantState) {
      Navigator.of(context).pop<MerchantData>(state.merchant);
      return;
    }

    if (state is ErrorMerchantState) {
      final existingMerchant = state.existingMerchant;
      if (existingMerchant != null) {
        Navigator.of(context).pop<MerchantData>(existingMerchant);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
}
