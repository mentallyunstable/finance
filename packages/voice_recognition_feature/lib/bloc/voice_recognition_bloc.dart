import 'dart:async';

import 'package:core/services/permission_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_platform_interface/voice_platform_interface.dart';
import 'package:voice_plugin/voice_plugin.dart';

part 'voice_recognition_bloc_event.dart';
part 'voice_recognition_bloc_state.dart';
part 'voice_recognition_bloc_state_data.dart';

final class VoiceRecognitionBloc extends Bloc<VoiceRecognitionBlocEvent, VoiceRecognitionBlocState> {
  final VoicePlugin _voicePlugin;
  final PermissionService _permissionService;

  VoiceRecognitionBloc({
    required VoicePlugin voicePlugin,
    required PermissionService permissionService,
  }) : _permissionService = permissionService,
       _voicePlugin = voicePlugin,
       super(VoiceRecognitionBlocState.initial(data: VoiceRecognitionBlocStateData.empty())) {
    on<VoiceRecognitionBlocEvent>(
      (event, emit) => switch (event) {
        final CheckAvailabilityVoiceRecognitionEvent e => _onCheckAvailabilityVoiceRecognitionEvent(e, emit),
        final StartListeningVoiceRecognitionEvent e => _onStartListeningVoiceRecognitionEvent(e, emit),
        final StopListeningVoiceRecognitionEvent e => _onStopListeningVoiceRecognitionEvent(e, emit),
        final ReceivedVoiceRecognitionEvent e => _onReceivedVoiceRecognitionEvent(e, emit),
        final FailedVoiceRecognitionEvent e => _onFailedVoiceRecognitionEvent(e, emit),
      },
    );
  }

  StreamSubscription<VoiceRecognitionSuccess>? _voiceResultListener;
  StreamSubscription<VoiceRecognitionError>? _voiceErrorListener;

  VoiceRecognitionBlocStateData get _currentData => state.data as VoiceRecognitionBlocStateData;

  @override
  Future<void> close() async {
    await _voicePlugin.stopListening();
    await _cancelSubscriptions();

    return super.close();
  }

  FutureOr<void> _onCheckAvailabilityVoiceRecognitionEvent(
    final CheckAvailabilityVoiceRecognitionEvent event,
    final Emitter<VoiceRecognitionBlocState> emit,
  ) async {
    // Check recognition availability
    final isAvailable = await _voicePlugin.checkAvailability();

    emit(
      VoiceRecognitionBlocState.initial(
        data: state.data.copyWith(isAvailable: isAvailable),
      ),
    );
  }

  FutureOr<void> _onStartListeningVoiceRecognitionEvent(
    final StartListeningVoiceRecognitionEvent event,
    final Emitter<VoiceRecognitionBlocState> emit,
  ) async {
    // Check microphone permission
    final hasPermission = await _permissionService.microphonePermissionStatus();

    // If not granted - request permission
    if (hasPermission != PermissionStatus.granted) {
      final requestStatus = await _permissionService.requestMicrophonePermission();

      // If permission is not granted - emit error state
      if (requestStatus != PermissionStatus.granted) {
        return emit(
          VoiceRecognitionBlocState.permissionError(
            data: state.data.copyWith(hasPermission: false),
          ),
        );
      }
    }

    emit(
      VoiceRecognitionBlocState.initial(
        data: _currentData.copyWith(
          hasPermission: true,
          results: [],
        ),
      ),
    );

    await _cancelSubscriptions();

    // Listen for recognition results using stream
    _voiceResultListener = _voicePlugin.rawTextStream.listen(
      (result) {
        add(VoiceRecognitionBlocEvent.received(result: result));
      },
    );

    // Listen for recognition errors using stream
    _voiceErrorListener = _voicePlugin.errors.listen(
      (error) {
        add(
          VoiceRecognitionBlocEvent.failed(
            code: error.code,
            message: error.message,
          ),
        );
      },
    );

    // Start voice recognition service
    try {
      await _voicePlugin.startListening();
    } on Exception catch (error) {
      await _cancelSubscriptions();

      emit(
        VoiceRecognitionBlocState.error(
          data: _currentData.copyWith(isListening: false),
          code: 'START_LISTENING_FAILED',
          message: error.toString(),
        ),
      );
      return;
    }

    // Set listening state to true
    emit(
      VoiceRecognitionBlocState.initial(
        data: state.data.copyWith(isListening: true),
      ),
    );
  }

  FutureOr<void> _onStopListeningVoiceRecognitionEvent(
    final StopListeningVoiceRecognitionEvent event,
    final Emitter<VoiceRecognitionBlocState> emit,
  ) async {
    await _voicePlugin.stopListening();

    emit(
      VoiceRecognitionBlocState.initial(
        data: _currentData.copyWith(isListening: false),
      ),
    );
  }

  FutureOr<void> _onReceivedVoiceRecognitionEvent(
    final ReceivedVoiceRecognitionEvent event,
    final Emitter<VoiceRecognitionBlocState> emit,
  ) async {
    final result = event.result;
    final text = result.text;

    if (text.isEmpty) {
      return;
    }

    if (result.type == VoiceRecognitionResultType.partial) {
      emit(
        VoiceRecognitionBlocState.initial(
          data: _currentData.copyWith(partialResult: text),
        ),
      );
      return;
    }

    if (result.type == VoiceRecognitionResultType.full) {
      await _cancelSubscriptions();

      emit(
        VoiceRecognitionBlocState.initial(
          data: VoiceRecognitionBlocStateData(
            isAvailable: _currentData.isAvailable,
            hasPermission: _currentData.hasPermission,
            isListening: false,
            partialResult: null,
            results: [..._currentData.results, text],
          ),
        ),
      );
    }
  }

  FutureOr<void> _onFailedVoiceRecognitionEvent(
    final FailedVoiceRecognitionEvent event,
    final Emitter<VoiceRecognitionBlocState> emit,
  ) async {
    await _cancelSubscriptions();

    if (event.code == 'CLIENT' && !state.data.isListening) {
      return;
    }

    emit(
      VoiceRecognitionBlocState.error(
        data: VoiceRecognitionBlocStateData(
          isAvailable: _currentData.isAvailable,
          hasPermission: _currentData.hasPermission,
          isListening: false,
          partialResult: null,
          results: _currentData.results,
        ),
        code: event.code,
        message: event.message,
      ),
    );
  }

  Future<void> _cancelSubscriptions() async {
    await _voiceResultListener?.cancel();
    await _voiceErrorListener?.cancel();
    _voiceResultListener = null;
    _voiceErrorListener = null;
  }
}
