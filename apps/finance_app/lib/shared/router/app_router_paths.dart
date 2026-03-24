part of 'app_router.dart';

/// Contains const routes paths and names.
sealed class AppRouterPaths {
  const AppRouterPaths._();

  static const initial = AppRouteEntry(path: '/', name: 'initial');

  // Branches
  static const main = AppRouteEntry(path: '/main', name: 'main');
}

/// Describes individual route entity with [path] and [name].
final class AppRouteEntry {
  final String path;
  final String name;

  const AppRouteEntry({required this.path, required this.name});
}
