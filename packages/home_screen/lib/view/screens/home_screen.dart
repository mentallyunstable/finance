import 'package:flutter/material.dart';
import 'package:home_screen/view/components/categories_spending_chart.dart';
import 'package:home_screen/view/components/total_balance_card.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            const SizedBox(height: 32),
            const TotalBalanceCard(),
            const SizedBox(height: 40),
            CategoriesSpendingChart(),
            const SizedBox(height: 1600),
          ],
        ),
      ),
    );
  }
}
