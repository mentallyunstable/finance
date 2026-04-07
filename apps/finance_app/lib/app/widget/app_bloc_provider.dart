import 'package:finance_app/app/dependencies/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';

final class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final repositories = context.repositories;

    // TODO: implement MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        // TransactionBlocProvider(),
        BlocProvider(create: (context) => TransactionBloc()),
      ],
      child: child,
    );
  }
}
