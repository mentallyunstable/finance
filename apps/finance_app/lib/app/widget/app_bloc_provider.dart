import 'package:finance_app/app/dependencies/extensions/context_extension.dart';
import 'package:flutter/material.dart';

final class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final repositories = context.repositories;

    // TODO: implement MultiBlocProvider
    return child;
  }
}
