import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:voice_platform_interface/voice_method_channel.dart';

abstract class VoicePlatform extends PlatformInterface {
  VoicePlatform() : super(token: _token);

  static final Object _token = Object();

  static VoicePlatform _instance = _createDefault();

  static VoicePlatform _createDefault() => MethodChannelVoice();

  static VoicePlatform get instance => _instance;

  static set instance(final VoicePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Start listening for voice input.
  Future<void> startListening();

  /// Stop listening for voice input.
  Future<void> stopListening();

  Stream<String> get results;
}
