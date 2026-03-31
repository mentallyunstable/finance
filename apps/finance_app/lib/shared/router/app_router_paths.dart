part of 'app_router.dart';

/// Contains const routes paths and names.
sealed class AppRouterPaths {
  const AppRouterPaths._();

  static const initial = AppRouteEntry(path: '/', name: 'initial');

  // Branches
  static const home = AppRouteEntry(path: '/home', name: 'home');
  static const history = AppRouteEntry(path: '/history', name: 'history');
  static const budgets = AppRouteEntry(path: '/budgets', name: 'budgets');
  static const settings = AppRouteEntry(path: '/settings', name: 'settings');

  // Screens
  static const voiceRecognition = AppRouteEntry(path: '/voice-recognition', name: 'voice-recognition');
  static const createTransaction = AppRouteEntry(path: '/create-transaction', name: 'create-transaction');
}

/// Describes individual route entity with [path] and [name].
final class AppRouteEntry {
  final String path;
  final String name;

  const AppRouteEntry({required this.path, required this.name});
}
