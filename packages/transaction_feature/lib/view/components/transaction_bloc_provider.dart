import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';

final class TransactionBlocProvider extends BlocProvider {
  TransactionBlocProvider({super.key}) : super(create: (_) => TransactionBloc());
}
