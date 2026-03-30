// ignore: depend_on_referenced_packages
import 'package:finance_app/app/dependencies/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_plugin/voice_plugin.dart';
import 'package:voice_recognition_feature/bloc/voice_recognition_bloc.dart';

final class VoiceRecognitionBlocProvider extends StatelessWidget {
  final Widget child;

  const VoiceRecognitionBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: get [VoicePlugin] object from DI
    return BlocProvider<VoiceRecognitionBloc>(
      create: (_) => VoiceRecognitionBloc(
        voicePlugin: VoicePlugin()..initialize(),
        permissionService: context.dependencies.services.permissionService,
      )..add(const VoiceRecognitionBlocEvent.checkAvailability()),
      child: child,
    );
  }
}
