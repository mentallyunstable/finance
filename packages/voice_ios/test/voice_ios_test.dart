import 'package:flutter_test/flutter_test.dart';
import 'package:voice_ios/voice_ios.dart';
import 'package:voice_ios/voice_ios_platform_interface.dart';
import 'package:voice_ios/voice_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVoiceIosPlatform
    with MockPlatformInterfaceMixin
    implements VoiceIosPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VoiceIosPlatform initialPlatform = VoiceIosPlatform.instance;

  test('$MethodChannelVoiceIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVoiceIos>());
  });

  test('getPlatformVersion', () async {
    VoiceIos voiceIosPlugin = VoiceIos();
    MockVoiceIosPlatform fakePlatform = MockVoiceIosPlatform();
    VoiceIosPlatform.instance = fakePlatform;

    expect(await voiceIosPlugin.getPlatformVersion(), '42');
  });
}
