part of 'voice_recognition_bloc.dart';

sealed class VoiceRecognitionBlocState {
  final BaseVoiceRecognitionBlocStateData data;

  const VoiceRecognitionBlocState({required this.data});

  const factory VoiceRecognitionBlocState.initial({
    required final BaseVoiceRecognitionBlocStateData data,
  }) = InitialVoiceRecognitionState;

  const factory VoiceRecognitionBlocState.permissionError({
    required final BaseVoiceRecognitionBlocStateData data,
  }) = PermissionErrorVoiceRecognitionState;
  const factory VoiceRecognitionBlocState.error({
    required final BaseVoiceRecognitionBlocStateData data,
    required final String code,
    required final String? message,
  }) = ErrorVoiceRecognitionBlocState;
}

final class InitialVoiceRecognitionState extends VoiceRecognitionBlocState {
  const InitialVoiceRecognitionState({required super.data});
}

final class PermissionErrorVoiceRecognitionState extends VoiceRecognitionBlocState {
  const PermissionErrorVoiceRecognitionState({required super.data});
}

final class ErrorVoiceRecognitionBlocState extends VoiceRecognitionBlocState {
  final String code;
  final String? message;

  const ErrorVoiceRecognitionBlocState({
    required super.data,
    required this.code,
    required this.message,
  });
}
