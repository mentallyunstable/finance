part of 'app_router.dart';

extension GoRouterExtensions on GoRouter {
  void pushVoiceRecognitionScreen() => pushNamed(AppRouterPaths.voiceRecognition.name);
}
