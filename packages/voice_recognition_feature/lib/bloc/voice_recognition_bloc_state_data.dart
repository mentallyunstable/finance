part of 'voice_recognition_bloc.dart';

abstract base class BaseVoiceRecognitionBlocStateData {
  final bool? isAvailable;
  final bool? hasPermission;
  final bool isListening;
  final String? partialResult;
  final List<String> results;

  const BaseVoiceRecognitionBlocStateData({
    required this.isAvailable,
    required this.hasPermission,
    required this.isListening,
    required this.partialResult,
    required this.results,
  });

  BaseVoiceRecognitionBlocStateData copyWith({
    bool? isAvailable,
    bool? hasPermission,
    bool? isListening,
    String? partialResult,
    List<String>? results,
  });
}

final class VoiceRecognitionBlocStateData extends BaseVoiceRecognitionBlocStateData {
  const VoiceRecognitionBlocStateData({
    required super.isAvailable,
    required super.hasPermission,
    required super.isListening,
    required super.partialResult,
    required super.results,
  });

  factory VoiceRecognitionBlocStateData.empty() => const VoiceRecognitionBlocStateData(
    isAvailable: null,
    hasPermission: null,
    isListening: false,
    partialResult: null,
    results: [],
  );

  @override
  BaseVoiceRecognitionBlocStateData copyWith({
    final bool? isAvailable,
    final bool? hasPermission,
    final bool? isListening,
    final String? partialResult,
    final List<String>? results,
  }) {
    return VoiceRecognitionBlocStateData(
      isAvailable: isAvailable ?? this.isAvailable,
      hasPermission: hasPermission ?? this.hasPermission,
      isListening: isListening ?? this.isListening,
      partialResult: partialResult ?? this.partialResult,
      results: results ?? this.results,
    );
  }
}
