import 'package:budgets_screen/view/screens/budgets_screen.dart';
import 'package:finance_app/app/widget/app_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:history_screen/view/screens/history_screen.dart';
import 'package:home_screen/view/screens/home_screen.dart';
import 'package:settings_screen/view/screens/settings_screen.dart';
import 'package:transaction_feature/view/screens/create_transaction_screen.dart';
import 'package:voice_recognition_feature/voice_recognition.dart';

part 'app_router_extensions.dart';
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
    initialLocation: AppRouterPaths.home.path,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      // Nested stack navigation using multiple [StatefulShellBranch].
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => AppShell(shell: child),
        parentNavigatorKey: rootNavigatorKey,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouterPaths.home.name,
                path: AppRouterPaths.home.path,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouterPaths.history.name,
                path: AppRouterPaths.history.path,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouterPaths.budgets.name,
                path: AppRouterPaths.budgets.path,
                builder: (context, state) => const BudgetsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRouterPaths.settings.name,
                path: AppRouterPaths.settings.path,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRouterPaths.voiceRecognition.path,
        name: AppRouterPaths.voiceRecognition.name,
        builder: (context, state) => const VoiceRecognitionScreen(),
      ),
      GoRoute(
        path: AppRouterPaths.createTransaction.path,
        name: AppRouterPaths.createTransaction.name,
        builder: (context, state) => const CreateTransactionScreen(),
      ),
    ],
  );
}
