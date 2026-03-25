import 'package:design_system/design_system.dart';
import 'package:finance_app/app/dependencies/extensions/context_extension.dart';
import 'package:finance_app/shared/router/app_router.dart';
import 'package:flutter/material.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
final class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = context.dependencies;
    final shellNavigatorKey = GlobalKey<NavigatorState>();

    final router = AppRouter(
      rootNavigatorKey: dependencies.navigatorKey,
      shellNavigatorKey: shellNavigatorKey,
    );

    return MaterialApp.router(
      routerConfig: router.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
