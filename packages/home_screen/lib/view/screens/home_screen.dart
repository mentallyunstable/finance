import 'package:category_feature/view/components/categories_spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_screen/view/components/total_balance_card.dart';
import 'package:transaction_feature/bloc/transaction_bloc.dart';
import 'package:transaction_feature/view/components/recent_activity_widget.dart';

final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  final _latestTransactionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionBlocState>(
      listenWhen: (previous, current) => current.data.transactions.length > previous.data.transactions.length,
      listener: (_, _) => WidgetsBinding.instance.addPostFrameCallback((_) => _revealLatestTransaction()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance'),
          actions: [
            IconButton(
              onPressed: () {},
              color: ColorScheme.of(context).primary,
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const .symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const TotalBalanceCard(),
              const SizedBox(height: 40),
              const CategoriesSpendingChart(),
              const SizedBox(height: 16),
              RecentActivityWidget(latestTransactionKey: _latestTransactionKey),
            ],
          ),
        ),
      ),
    );
  }

  void _revealLatestTransaction() {
    final latestTransactionContext = _latestTransactionKey.currentContext;

    if (!mounted || latestTransactionContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      latestTransactionContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }
}
