import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:voice_platform_interface/data/result/voice_recognition_result.dart';
import 'package:voice_platform_interface/voice_method_channel.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';

abstract class VoicePlatform extends PlatformInterface {
  VoicePlatform() : super(token: _token);

  static final Object _token = Object();

  static VoicePlatform _instance = _createDefault();

  static VoicePlatform _createDefault() => MethodChannelVoice();

  /// The default instance of [VoicePlatform].
  static VoicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own platform-specific class
  /// that extends [VoicePlatform] when they register themselves.
  static set instance(final VoicePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Check if voice recognition service is available on the device and can be enabled.
  Future<bool> checkAvailability();

  /// Start listening for voice input.
  Future<void> startListening({
    final String? locale,
    final bool preferOffline,
  });

  /// Stop listening for voice input.
  Future<void> stopListening();

  /// Stream of recognized text results from the platform layer.
  Stream<VoiceRecognitionSuccess> get results;

  /// Stream of errors from the platform layer.
  Stream<VoiceRecognitionError> get errors;
}
