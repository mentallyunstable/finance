import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:voice_android/voice_android_platform.dart';
import 'package:voice_platform_interface/voice_method_channel.dart';

class MockVoiceAndroidPlatform with MockPlatformInterfaceMixin implements VoiceAndroidPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VoiceAndroidPlatform initialPlatform = VoiceAndroidPlatform.instance;

  test('$MethodChannelVoice is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVoice>());
  });

  test('getPlatformVersion', () async {
    VoiceAndroidPlatform voiceAndroidPlugin = VoiceAndroidPlatform();
    MockVoiceAndroidPlatform fakePlatform = MockVoiceAndroidPlatform();
    VoiceAndroidPlatform.instance = fakePlatform;

    expect(await voiceAndroidPlugin.getPlatformVersion(), '42');
  });
}
