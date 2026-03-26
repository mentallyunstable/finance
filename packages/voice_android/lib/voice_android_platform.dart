import 'package:core/utils/extensions/map_extensions.dart';
import 'package:flutter/services.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';

class VoiceAndroidPlatform extends VoicePlatform {
  static const _methodChannelName = 'voice_method_channel_android';
  static const _eventChannelName = 'voice_event_channel_android';

  static const _checkAvailabilityMethod = 'checkAvailability';
  static const _startListeningMethod = 'startListening';
  static const _stopListeningMethod = 'stopListening';

  final _methodChannel = const MethodChannel(_methodChannelName);
  final _eventChannel = const EventChannel(_eventChannelName);

  @override
  Future<bool> checkAvailability() async {
    final result = await _methodChannel.invokeMethod(_checkAvailabilityMethod) as bool;

    return result;
  }

  @override
  Future<void> startListening({
    final String? locale,
    final bool preferOffline = false,
  }) async {
    await _methodChannel.invokeMethod(
      _startListeningMethod,
      {'locale': locale, 'preferOffline': preferOffline},
    );
  }

  late final Stream<VoiceRecognitionResult> _events = _eventChannel
      .receiveBroadcastStream()
      .map((event) {
        if (event is! Map) {
          throw StateError('Expected map from EventChannel, got ${event.runtimeType}');
        }

        final normalized = event.normalize();

        return VoiceRecognitionResult.fromString(normalized);
      })
      .asBroadcastStream();

  @override
  Future<void> stopListening() async {
    await _methodChannel.invokeMethod(_stopListeningMethod);
  }

  @override
  Stream<VoiceRecognitionSuccess> get results => _events
      .where(
        (event) => event.type == VoiceRecognitionResultType.full || event.type == VoiceRecognitionResultType.partial,
      )
      .map((event) => event as VoiceRecognitionSuccess);

  @override
  Stream<VoiceRecognitionError> get errors => _events
      .where((event) => event.type == VoiceRecognitionResultType.error)
      .map((data) => data as VoiceRecognitionError);
}
