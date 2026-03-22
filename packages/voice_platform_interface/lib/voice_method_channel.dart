import 'package:voice_platform_interface/voice_platform_interface.dart';

/// Default implementation of VoicePlatform with no functionality.
/// See [VoiceAndroidPlatform] and [VoiceIosPlatform] for actual implementations.
class MethodChannelVoice extends VoicePlatform {
  @override
  Future<void> startListening() async => throw UnimplementedError();

  @override
  Stream<String> get results => throw UnimplementedError();

  @override
  Future<void> stopListening() => throw UnimplementedError();
}
