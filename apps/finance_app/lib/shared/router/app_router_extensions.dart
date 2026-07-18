part of 'app_router.dart';

extension GoRouterExtensions on GoRouter {
  Future<T?> pushCreateTransactionScreen<T extends Object?>() => pushNamed<T>(AppRouterPaths.createTransaction.name);

  void pushVoiceRecognitionScreen() => pushNamed(AppRouterPaths.voiceRecognition.name);
}
