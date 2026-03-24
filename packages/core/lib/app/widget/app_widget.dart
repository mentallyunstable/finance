import 'package:core/app/widget/app_bloc_provider.dart';
import 'package:core/initialization/model/initialization_result.dart';
import 'package:core/initialization/widget/dependencies_scope.dart';
import 'package:finance_app/app/material_context.dart';
import 'package:flutter/material.dart';

/// [AppWidget] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
class AppWidget extends StatelessWidget {
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
