part of 'app_router.dart';

extension GoRouterExtensions on GoRouter {
  void pushCreateTransactionScreen() => pushNamed(AppRouterPaths.createTransaction.name);

  void pushVoiceRecognitionScreen() => pushNamed(AppRouterPaths.voiceRecognition.name);
}
