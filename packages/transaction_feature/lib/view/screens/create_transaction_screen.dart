import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';
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

  final _amountNotifier = ValueNotifier('0');

  final ValueNotifier _isListening = ValueNotifier(false);

  @override
  void dispose() {
    _amountNotifier.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoiceRecognitionBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(
            bottom: MediaQuery.viewPaddingOf(context).bottom,
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
                const SizedBox(height: 40),
                TransactionKeyboard(
                  onKeyPressed: _addAmount,
                  onPointPressed: _onPointPressed,
                  onRemovePressed: _onRemovePressed,
                ),
                const SizedBox(height: 40),
                // TODO: add category selector
                TextFormField(
                  controller: _categoryController,
                  keyboardType: .text,
                ),
                const SizedBox(height: 40),
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
                  builder: (context, state) => Column(
                    spacing: 16,
                    children: [
                      VoiceRecognitionIconButton(
                        onPressed: () {
                          final bloc = context.read<VoiceRecognitionBloc>();

                          state.data.isListening
                              ? bloc.add(const VoiceRecognitionBlocEvent.stopListening())
                              : bloc.add(const VoiceRecognitionBlocEvent.startListening());
                        },
                        isListening: state.data.isListening,
                      ),
                      Text(state.data.results.join()),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                AppMainButton(
                  title: 'Save Transaction',
                  onPressed: _createTransaction,
                ),
              ],
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

  void _createTransaction() {
    context.read<TransactionBloc>().add(
      TransactionBlocEvent.create(
        title: '',
        amount: _amountNotifier.value,
        categoryId: _categoryController.text,
        merchant: null,
        notes: null,
      ),
    );
  }
}
