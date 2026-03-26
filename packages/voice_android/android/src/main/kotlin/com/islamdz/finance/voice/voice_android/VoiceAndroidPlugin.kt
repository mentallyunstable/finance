package com.islamdz.finance.voice.voice_android

import android.content.Intent
import android.app.Activity
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** VoiceAndroidPlugin */
class VoiceAndroidPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,
    RecognitionListener, ActivityAware {
    companion object {
        private const val METHOD_CHANNEL_NAME = "voice_method_channel_android"
        private const val EVENT_CHANNEL_NAME = "voice_event_channel_android"
        private const val AVAILABILITY_METHOD_NAME = "checkAvailability"
        private const val START_LISTENING_METHOD_NAME = "startListening"
        private const val STOP_LISTENING_METHOD_NAME = "stopListening"
    }

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null
    private var speechRecognizer: SpeechRecognizer? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // Init MethodChannel
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)

        // Init EventChannel
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        speechRecognizer?.cancel()
        speechRecognizer?.destroy()
        speechRecognizer = null

        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall, result: Result
    ) {
        when (call.method) {
            AVAILABILITY_METHOD_NAME -> result.success(activity?.let {
                SpeechRecognizer.isRecognitionAvailable(it)
            } ?: false)

            START_LISTENING_METHOD_NAME -> {
                val currentActivity = activity
                if (currentActivity == null) {
                    result.error("NO_ACTIVITY", "No activity is attached to the plugin", null)
                    return
                }

                val isAvailable = SpeechRecognizer.isRecognitionAvailable(currentActivity)
                if (!isAvailable) {
                    result.error(
                        "NOT_AVAILABLE",
                        "Speech recognition is not available on this device",
                        null
                    )
                    return
                }

                val locale = call.argument<String>("locale")
                val preferOffline = call.argument<Boolean>("preferOffline") ?: false

                try {
                    val recognizer = spawnRecognizer()
                    val intent = spawnRecognizerIntent(locale, preferOffline)

                    println("VoiceAndroidPlugin: startListening locale=$locale preferOffline=$preferOffline")
                    recognizer.startListening(intent)
                    result.success(null)
                } catch (exception: Exception) {
                    result.error(
                        "START_LISTENING_FAILED",
                        "Failed to start speech recognition: ${exception.message}",
                        null
                    )
                }
            }

            STOP_LISTENING_METHOD_NAME -> {
                speechRecognizer?.stopListening()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onListen(
        arguments: Any?, events: EventChannel.EventSink?
    ) {
        println("VoiceAndroidPlugin: EventChannel onListen")
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        println("VoiceAndroidPlugin: EventChannel onCancel")
        eventSink = null
    }

    private fun spawnRecognizer(): SpeechRecognizer {
        val currentActivity =
            activity ?: throw IllegalArgumentException("Activity is not attached")

        return speechRecognizer ?: SpeechRecognizer.createSpeechRecognizer(currentActivity).also {
            it.setRecognitionListener(this)
            speechRecognizer = it
        }
    }

    private fun spawnRecognizerIntent(
        locale: String?,
        preferOffline: Boolean,
    ): Intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
        putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
        putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, preferOffline)

        locale?.let {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, it)
        }
    }

    override fun onReadyForSpeech(params: Bundle?) {
        println("VoiceAndroidPlugin: onReadyForSpeech")
    }

    override fun onBeginningOfSpeech() {
        println("VoiceAndroidPlugin: onBeginningOfSpeech")
    }

    override fun onEndOfSpeech() {
        println("VoiceAndroidPlugin: onEndOfSpeech")
    }

    override fun onRmsChanged(rmsdB: Float) {
    }

    override fun onBufferReceived(buffer: ByteArray?) {
    }

    override fun onError(error: Int) {
        println("VoiceAndroidPlugin: onError code=$error mapped=${mapErrorCode(error)}")

        eventSink?.success(
            mapOf(
                "type" to "error",
                "code" to mapErrorCode(error),
                "message" to "Speech recognition failed"
            )
        )
    }

    override fun onResults(results: Bundle?) {
        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)

        println("VoiceAndroidPlugin: onResults matches=$matches")

        val text = matches?.firstOrNull() ?: return

        eventSink?.success(
            mapOf(
                "type" to "full",
                "text" to text
            )
        )
    }

    override fun onPartialResults(partialResults: Bundle?) {
        val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        val text = matches?.firstOrNull() ?: return

        println("VoiceAndroidPlugin: onPartialResults matches=$matches")

        eventSink?.success(
            mapOf(
                "type" to "partial",
                "text" to text
            )
        )
    }

    override fun onEvent(eventType: Int, params: Bundle?) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun mapErrorCode(error: Int): String {
        return when (error) {
            SpeechRecognizer.ERROR_AUDIO -> "AUDIO"
            SpeechRecognizer.ERROR_CLIENT -> "CLIENT"
            SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "INSUFFICIENT_PERMISSIONS"
            SpeechRecognizer.ERROR_NETWORK -> "NETWORK"
            SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "NETWORK_TIMEOUT"
            SpeechRecognizer.ERROR_NO_MATCH -> "NO_MATCH"
            SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "RECOGNIZER_BUSY"
            SpeechRecognizer.ERROR_SERVER -> "SERVER"
            SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "SPEECH_TIMEOUT"
            else -> "UNKNOWN"
        }
    }
}
