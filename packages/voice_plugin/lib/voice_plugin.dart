library;

import 'dart:async';
import 'dart:io';

import 'package:voice_android/voice_android_platform.dart';
import 'package:voice_ios/voice_ios_platform.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';

class VoicePlugin {
  VoicePlugin._internal();

  static final VoicePlugin _instance = VoicePlugin._internal();

  factory VoicePlugin() => _instance;

  /// Initialize plugin (permissions, setup, etc.)
  void initialize() {
    if (Platform.isAndroid) {
      VoicePlatform.instance = VoiceAndroidPlatform();
    } else {
      VoicePlatform.instance = VoiceIosPlatform();
    }
  }

  Future<bool> checkAvailability() async {
    return VoicePlatform.instance.checkAvailability();
  }

  /// Start voice recognition
  Future<void> startListening() {
    return VoicePlatform.instance.startListening();
  }

  /// Stop voice recognition
  Future<void> stopListening() {
    return VoicePlatform.instance.stopListening();
  }

  /// Raw recognized text stream
  Stream<VoiceRecognitionSuccess> get rawTextStream => VoicePlatform.instance.results;

  /// Errors from platform layer
  Stream<VoiceRecognitionError> get errors => VoicePlatform.instance.errors;

  // /// High-level API (recommended)
  // VoiceService get service => _service;
}
