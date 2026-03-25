import 'package:flutter/services.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';

class VoiceIosPlatform extends VoicePlatform {
  static const _methodChannelName = 'voice_method_channel_ios';
  static const _eventChannelName = 'voice_event_channel_ios';

  final _channel = const MethodChannel(_methodChannelName);
  final _eventChannel = const EventChannel(_eventChannelName);

  @override
  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');

    _eventChannel.receiveBroadcastStream().map((event) {
      if (event is String) {
        return event;
      } else {
        throw const FormatException('Expected a string from event channel');
      }
    });
  }

  @override
  Future<void> stopListening() async {
    await _channel.invokeMethod('stopListening');
  }

  @override
  Stream<String> get results => throw UnimplementedError();
}
