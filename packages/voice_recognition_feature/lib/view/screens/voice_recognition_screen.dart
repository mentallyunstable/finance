import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_recognition_feature/bloc/voice_recognition_bloc.dart';
import 'package:voice_recognition_feature/view/components/voice_recognition_bloc_provider.dart';

final class VoiceRecognitionScreen extends StatelessWidget {
  const VoiceRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VoiceRecognitionBlocProvider(
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<VoiceRecognitionBloc, VoiceRecognitionBlocState>(
          builder: (context, state) {
            final data = state.data;
            final isAvailable = data.isAvailable;

            return Center(
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Is available: $isAvailable'),
                  ElevatedButton(
                    child: Text(data.isListening ? 'Stop listening' : 'Start listening'),
                    onPressed: () {
                      if (data.isListening) {
                        context.read<VoiceRecognitionBloc>().add(const VoiceRecognitionBlocEvent.stopListening());
                      } else {
                        context.read<VoiceRecognitionBloc>().add(
                          const VoiceRecognitionBlocEvent.startListening(),
                        );
                      }
                    },
                  ),
                  Text('Partial: ${data.partialResult ?? '-'}'),
                  Text('Results: ${data.results}'),
                  if (state is ErrorVoiceRecognitionBlocState)
                    Text(
                      'Error code: ${state.code}, message: ${state.message}',
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
