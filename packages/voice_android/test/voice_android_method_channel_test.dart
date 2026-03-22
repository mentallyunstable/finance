import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_platform_interface/voice_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVoice platform = MethodChannelVoice();
  const MethodChannel channel = MethodChannel('voice_android');

  // TODO: implement tests for MethodChannelVoice
}
