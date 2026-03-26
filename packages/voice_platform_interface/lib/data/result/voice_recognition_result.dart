sealed class VoiceRecognitionResult {
  final VoiceRecognitionResultType type;

  const VoiceRecognitionResult({required this.type});

  factory VoiceRecognitionResult.fromString(Map<String, dynamic> map) {
    final type = map['type'];

    if (type == null) {
      throw ArgumentError('Invalid VoiceRecognitionResult: missing "type" field');
    }

    return switch (type) {
      'error' => VoiceRecognitionError.fromJson(map),
      'full' || 'partial' => VoiceRecognitionSuccess.fromJson(map),
      _ => throw ArgumentError('Invalid VoiceRecognitionResult type: $type'),
    };
  }
}

final class VoiceRecognitionSuccess extends VoiceRecognitionResult {
  final String text;

  const VoiceRecognitionSuccess({
    required this.text,
    required super.type,
  });

  factory VoiceRecognitionSuccess.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = VoiceRecognitionResultType.fromString(typeString);

    return VoiceRecognitionSuccess(
      text: json['text'] as String,
      type: type,
    );
  }
}

final class VoiceRecognitionError extends VoiceRecognitionResult {
  final String code;
  final String? message;

  const VoiceRecognitionError({
    required this.code,
    this.message,
  }) : super(type: VoiceRecognitionResultType.error);

  factory VoiceRecognitionError.fromJson(Map<String, dynamic> json) {
    return VoiceRecognitionError(
      code: json['code'] as String,
      message: json['message'] as String?,
    );
  }
}

enum VoiceRecognitionResultType {
  error,
  full,
  partial
  ;

  static VoiceRecognitionResultType fromString(final String value) {
    return switch (value) {
      'full' => VoiceRecognitionResultType.full,
      'partial' => VoiceRecognitionResultType.partial,
      'error' => VoiceRecognitionResultType.error,
      _ => throw ArgumentError('Invalid VoiceRecognitionResultType: $value'),
    };
  }
}
