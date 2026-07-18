part of 'app_router.dart';

extension GoRouterExtensions on GoRouter {
  Future<T?> pushCreateTransactionScreen<T extends Object?>() => pushNamed<T>(AppRouterPaths.createTransaction.name);

  Future<T?> pushAddMerchantScreen<T extends Object?>(String initialName) =>
      pushNamed<T>(AppRouterPaths.addMerchant.name, extra: initialName);

  void pushVoiceRecognitionScreen() => pushNamed(AppRouterPaths.voiceRecognition.name);
}
