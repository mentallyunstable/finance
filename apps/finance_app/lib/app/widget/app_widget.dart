import 'package:finance_app/app/initialization/model/initialization_result.dart';
import 'package:finance_app/app/initialization/widget/dependencies_scope.dart';
import 'package:finance_app/app/widget/app_bloc_provider.dart';
import 'package:finance_app/app/widget/material_context.dart';
import 'package:flutter/material.dart';

/// {@template app_widget}
/// [AppWidget] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
final class AppWidget extends StatelessWidget {
  /// {@macro app}
  const AppWidget({required this.result, super.key});

  /// The result from the [CompositionRoot].
  final InitializationResult result;

  @override
  Widget build(BuildContext context) {
    final dependencies = result.dependencies;

    return DependenciesScope(
      dependencies: dependencies,
      child: const AppBlocProvider(
        child: MaterialContext(),
      ),
    );
  }
}
