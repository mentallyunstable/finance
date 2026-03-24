import 'package:finance_app/app/home/home_screen.dart';
import 'package:finance_app/app/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

part 'app_router_paths.dart';

/// Defines app navigation service using go_router package.
final class AppRouter {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> shellNavigatorKey;

  AppRouter({
    required this.rootNavigatorKey,
    required this.shellNavigatorKey,
  });

  /// Creates [GoRouter] instance for app navigation.
  late final router = GoRouter(
    initialLocation: AppRouterPaths.main.path,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      // Nested stack navigation using multiple [StatefulShellBranch].
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => HomeScreen(shell: child),
        parentNavigatorKey: rootNavigatorKey,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouterPaths.main.name,
                path: AppRouterPaths.main.path,
                builder: (context, state) => const MainScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
