import 'package:flutter/services.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';

class VoiceAndroidPlatform extends VoicePlatform {
  static const _methodChannelName = 'voice_method_channel_android';

  final _channel = const MethodChannel(_methodChannelName);

  @override
  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');
  }

  @override
  Stream<String> get results => throw UnimplementedError();

  @override
  Future<void> stopListening() async {
    await _channel.invokeMethod('stopListening');
  }
}
