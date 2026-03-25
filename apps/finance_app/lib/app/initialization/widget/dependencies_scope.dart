import 'package:finance_app/app/dependencies/model/dependencies_container.dart';
import 'package:flutter/cupertino.dart';

class DependenciesScope extends InheritedWidget {
  final DependenciesContainer dependencies;

  const DependenciesScope({
    super.key,
    required super.child,
    required this.dependencies,
  });

  static DependenciesContainer? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DependenciesScope>()?.dependencies;

  static DependenciesContainer of(BuildContext context) {
    final dependencies = maybeOf(context);

    if (dependencies == null) {
      throw ArgumentError(
        'Out of scope, not found inherited widget '
            'DependenciesScope of the exact type',
        'out_of_scope',
      );
    }

    return dependencies;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
