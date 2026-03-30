import 'package:core/utils/extensions/map_extensions.dart';
import 'package:voice_platform_interface/data/result/voice_recognition_result.dart';

extension StreamExtensions on Stream {
  Stream<VoiceRecognitionResult> mapToResult() => map((entry) {
    if (entry is! Map) {
      throw StateError('Expected map, got ${entry.runtimeType}');
    }

    final normalized = entry.normalize();

    return VoiceRecognitionResult.fromString(normalized);
  }).asBroadcastStream();

  Stream<VoiceRecognitionSuccess> mapToSuccess() => where(
    (event) => event.type == VoiceRecognitionResultType.full || event.type == VoiceRecognitionResultType.partial,
  ).map((event) => event as VoiceRecognitionSuccess);

  Stream<VoiceRecognitionError> mapToError() => where(
    (event) => event.type == VoiceRecognitionResultType.error,
  ).map((data) => data as VoiceRecognitionError);
}
