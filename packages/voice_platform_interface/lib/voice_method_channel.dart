import 'package:voice_platform_interface/voice_platform_interface.dart';

/// Default implementation of VoicePlatform with no functionality.
/// See [VoiceAndroidPlatform] and [VoiceIosPlatform] for actual implementations.
class MethodChannelVoice extends VoicePlatform {
  @override
  Future<bool> checkAvailability() => throw UnimplementedError();

  @override
  Future<void> startListening({
    final String? locale,
    final bool? preferOffline,
  }) async => throw UnimplementedError();

  @override
  Future<void> stopListening() => throw UnimplementedError();

  @override
  Stream<VoiceRecognitionSuccess> get results => throw UnimplementedError();

  @override
  Stream<VoiceRecognitionError> get errors => throw UnimplementedError();
}
