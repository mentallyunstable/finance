import 'package:category_feature/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';

final class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement MultiBlocProvider
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TransactionBloc()),
        BlocProvider(create: (context) => CategoryBloc()),
      ],
      child: child,
    );
  }
}
