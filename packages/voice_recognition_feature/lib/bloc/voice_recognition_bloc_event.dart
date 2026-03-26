part of 'voice_recognition_bloc.dart';

sealed class VoiceRecognitionBlocEvent {
  const VoiceRecognitionBlocEvent();

  const factory VoiceRecognitionBlocEvent.checkAvailability() = CheckAvailabilityVoiceRecognitionEvent;

  const factory VoiceRecognitionBlocEvent.startListening() = StartListeningVoiceRecognitionEvent;

  const factory VoiceRecognitionBlocEvent.stopListening() = StopListeningVoiceRecognitionEvent;

  const factory VoiceRecognitionBlocEvent.received({
    required final VoiceRecognitionSuccess result,
  }) = ReceivedVoiceRecognitionEvent;

  const factory VoiceRecognitionBlocEvent.failed({
    required final String code,
    required final String? message,
  }) = FailedVoiceRecognitionEvent;
}

final class CheckAvailabilityVoiceRecognitionEvent extends VoiceRecognitionBlocEvent {
  const CheckAvailabilityVoiceRecognitionEvent();
}

final class StartListeningVoiceRecognitionEvent extends VoiceRecognitionBlocEvent {
  const StartListeningVoiceRecognitionEvent();
}

final class StopListeningVoiceRecognitionEvent extends VoiceRecognitionBlocEvent {
  const StopListeningVoiceRecognitionEvent();
}

final class ReceivedVoiceRecognitionEvent extends VoiceRecognitionBlocEvent {
  final VoiceRecognitionSuccess result;

  const ReceivedVoiceRecognitionEvent({required this.result});
}

final class FailedVoiceRecognitionEvent extends VoiceRecognitionBlocEvent {
  final String code;
  final String? message;

  const FailedVoiceRecognitionEvent({required this.code, required this.message});
}
