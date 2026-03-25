import 'package:finance_app/app/dependencies/model/dependencies_container.dart';

final class InitializationResult {
  final DependenciesContainer dependencies;
  final int msSpent;

  InitializationResult({required this.dependencies, required this.msSpent});

  @override
  String toString() =>
      '$InitializationResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
