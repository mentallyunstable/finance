import AVFoundation
import Flutter
import Speech
import UIKit

/*
 iOS implementation of the voice plugin.

 The plugin exposes a MethodChannel for imperative calls such as
 availability/start/stop and an EventChannel for streaming recognition
 results back to Dart.
 */
public class VoiceIosPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private static let methodChannelName = "voice_method_channel_ios"
    private static let eventChannelName = "voice_event_channel_ios"

    private let checkAvailabilityMethod = "checkAvailability"
    private let startListeningMethod = "startListening"
    private let stopListeningMethod = "stopListening"

    private let audioEngine = AVAudioEngine()
    private var eventSink: FlutterEventSink?
    private var recognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    /*
     Registers both Flutter channels.

     Method calls control the speech session lifecycle, while the event
     channel pushes partial/final/error payloads to the Dart layer.
     */
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: methodChannelName,
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: eventChannelName,
            binaryMessenger: registrar.messenger()
        )
        let instance = VoiceIosPlugin()

        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {

        let arguments = call.arguments as? [String: Any]
        let localeIdentifier = arguments?["locale"] as? String
        let preferOffline = arguments?["preferOffline"] as? Bool ?? false
        let locale = localeIdentifier.map(Locale.init(identifier:))

        recognizer = createRecognizer(locale)

        switch call.method {
        case checkAvailabilityMethod:
            checkAvailability(result)
        case startListeningMethod:
            startListening(
                result: result,
                locale: locale,
                preferOffline: preferOffline
            )
        case stopListeningMethod:
            stopListening(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func createRecognizer(_ locale: Locale? = nil)
        -> SFSpeechRecognizer?
    {
        if let locale {
            recognizer = createRecognizerForRequestedLocale(locale)
        }

        if recognizer == nil {
            recognizer = SFSpeechRecognizer()
        }

        return recognizer
    }

    private func createRecognizerForRequestedLocale(_ locale: Locale)
        -> SFSpeechRecognizer?
    {
        let supportedLocales = SFSpeechRecognizer.supportedLocales()

        if supportedLocales.contains(where: {
            $0.identifier.caseInsensitiveCompare(locale.identifier) == .orderedSame
        }) {
            return SFSpeechRecognizer(locale: locale)
        }

        guard let languageCode = locale.languageCode else {
            return nil
        }

        let fallbackLocale = supportedLocales.first {
            $0.languageCode?.caseInsensitiveCompare(languageCode) == .orderedSame
        }

        guard let fallbackLocale else {
            return nil
        }

        return SFSpeechRecognizer(locale: fallbackLocale)
    }

    /*
     Called by Flutter when Dart starts listening to the EventChannel.

     Flutter creates the sink instance and passes it here. The plugin stores
     it so native callbacks can stream structured payloads back to Dart.
     */
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        eventSink = events
        return nil
    }

    /*
     Called by Flutter when Dart cancels the EventChannel subscription.
     */
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private func checkAvailability(_ result: @escaping FlutterResult) {
        result(recognizer?.isAvailable ?? false)
    }

    private func startListening(
        result: @escaping FlutterResult,
        locale: Locale?,
        preferOffline: Bool = false
    ) {
        guard let recognizer = self.recognizer else {
            result(
                FlutterError(
                    code: "NOT_AVAILABLE",
                    message:
                        "Speech recognition is not available for the requested locale",
                    details: nil
                )
            )
            return
        }

        guard recognizer.isAvailable else {
            result(
                FlutterError(
                    code: "NOT_AVAILABLE",
                    message:
                        "Speech recognition is not available on this device",
                    details: nil
                )
            )
            return
        }

        /*
         Speech authorization is asynchronous on Apple platforms, so we only
         start audio capture after the authorization callback returns.
         */
        requestSpeechAuthorization { [weak self] authorized in
            guard let self else {
                result(
                    FlutterError(
                        code: "PLUGIN_DEALLOCATED",
                        message: "VoiceIosPlugin is no longer available",
                        details: nil
                    )
                )
                return
            }

            guard authorized else {
                result(
                    FlutterError(
                        code: "SPEECH_AUTH_DENIED",
                        message: "Speech recognition authorization was denied",
                        details: nil
                    )
                )
                return
            }

            do {
                try self.beginRecording(
                    with: recognizer,
                    preferOffline: preferOffline,
                )
                result(nil)
            } catch {
                result(
                    FlutterError(
                        code: "START_LISTENING_FAILED",
                        message:
                            "Failed to start speech recognition: \(error.localizedDescription)",
                        details: nil
                    )
                )
            }
        }
    }

    /*
     Stops feeding audio to the recognizer but still gives iOS a chance to
     produce a final result. A delayed cleanup acts as a safety net in case
     the native callback never completes the session on its own.
     */
    private func stopListening(_ result: @escaping FlutterResult) {
        guard
            (recognitionRequest != nil && recognitionTask != nil)
                || audioEngine.isRunning
        else {
            cleanupRecognition()
            result(nil)
            return
        }

        if audioEngine.isRunning {
            audioEngine.stop()
        }

        removeInputTapIfNeeded()
        recognitionRequest?.endAudio()

        if recognitionTask == nil {
            cleanupRecognition()
        }

        scheduleForcedCleanupIfNeeded()
        result(nil)
    }

    /*
     Resolves Apple speech-recognition authorization into a simple Bool for
     the plugin flow.
     */
    private func requestSpeechAuthorization(
        completion: @escaping (Bool) -> Void
    ) {
        let status = SFSpeechRecognizer.authorizationStatus()

        switch status {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        case .denied, .restricted:
            completion(false)
        case .authorized:
            completion(true)
        @unknown default:
            completion(false)
        }
    }

    /*
     Creates a fresh speech session and begins streaming microphone buffers
     into Apple's speech recognizer.

     Each new start request tears down any previous session first so repeated
     start/stop cycles do not reuse stale native objects.
     */
    private func beginRecording(
        with recognizer: SFSpeechRecognizer,
        preferOffline: Bool
    ) throws {
        cleanupRecognition()

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(
            .record,
            mode: .measurement,
            options: .duckOthers
        )
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        guard isValidRecordingFormat(recordingFormat) else {
            try? audioSession.setActive(
                false,
                options: .notifyOthersOnDeactivation
            )
            throw VoiceIosPluginError.invalidRecordingFormat(
                sampleRate: recordingFormat.sampleRate,
                channelCount: recordingFormat.channelCount
            )
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition =
            preferOffline && recognizer.supportsOnDeviceRecognition
        recognitionRequest = request

        inputNode.removeTap(onBus: 0)

        recognitionTask = recognizer.recognitionTask(with: request) {
            [weak self] recognitionResult, error in
            guard let self else {
                return
            }

            if let recognitionResult {
                let text = recognitionResult.bestTranscription.formattedString

                if !text.isEmpty {
                    /*
                     Match the payload shape used by the Android plugin so the
                     shared Dart layer can parse both platforms the same way.
                     */
                    self.eventSink?([
                        "type": recognitionResult.isFinal ? "full" : "partial",
                        "text": text,
                    ])
                }

                if recognitionResult.isFinal {
                    self.cleanupRecognition()
                    return
                }
            }

            if let error {
                self.emitError(
                    code: "RECOGNITION_ERROR",
                    message: error.localizedDescription
                )
                self.cleanupRecognition()
            }
        }

        let tapFailure = VoiceAudioTapInstaller.installTap(
            on: inputNode,
            bus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        if let tapFailure {
            cleanupRecognition()
            throw VoiceIosPluginError.audioTapInstallFailed(tapFailure)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    /*
     Tears down the active recognition session and releases audio resources.

     This is intentionally the single cleanup path used by start, stop, and
     recognition callbacks to keep the native lifecycle predictable.
     */
    private func cleanupRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }

        removeInputTapIfNeeded()

        recognitionRequest?.endAudio()
        recognitionRequest = nil

        recognitionTask?.cancel()
        recognitionTask = nil

        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }

    /*
     Forces cleanup if `stopListening` requested a graceful shutdown but the
     recognizer never delivers a terminal callback.
     */
    private func scheduleForcedCleanupIfNeeded() {
        let currentTask = recognitionTask

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            guard self.recognitionTask === currentTask else { return }

            self.cleanupRecognition()
        }
    }

    private func removeInputTapIfNeeded() {
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    private func isValidRecordingFormat(_ format: AVAudioFormat) -> Bool {
        format.sampleRate > 0 && format.channelCount > 0
    }

    /*
     Send error to the EventChannel.
     */
    private func emitError(code: String, message: String) {
        eventSink?([
            "type": "error",
            "code": code,
            "message": message,
        ])
    }
}

private enum VoiceIosPluginError: LocalizedError {
    case invalidRecordingFormat(
        sampleRate: Double,
        channelCount: AVAudioChannelCount
    )
    case audioTapInstallFailed(String)

    var errorDescription: String? {
        switch self {
        case let .invalidRecordingFormat(sampleRate, channelCount):
            return
                "No valid microphone input format is available. sampleRate=\(sampleRate), channelCount=\(channelCount)"
        case let .audioTapInstallFailed(message):
            return "Failed to install microphone recording tap: \(message)"
        }
    }
}
