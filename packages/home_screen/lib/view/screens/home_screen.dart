import 'package:flutter/material.dart';
import 'package:home_screen/view/components/categories_spending_chart.dart';
import 'package:home_screen/view/components/total_balance_card.dart';
import 'package:transaction_feature/view/components/recent_activity_widget.dart';

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
      body: const SingleChildScrollView(
        padding: .symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            TotalBalanceCard(),
            SizedBox(height: 40),
            CategoriesSpendingChart(),
            SizedBox(height: 16),
            RecentActivityWidget(),
          ],
        ),
      ),
    );
  }
}
