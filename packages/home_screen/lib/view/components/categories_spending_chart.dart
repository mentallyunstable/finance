import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final class CategoriesSpendingChart extends StatelessWidget {
  const CategoriesSpendingChart({super.key});

  final _maxSpending = 1000.0;
  final _minSpending = 0.0;

  static const _categories = [
    CategoryData(
      label: 'Food',
      value: 1000,
      color: Colors.blue,
      icon: Icons.restaurant_outlined,
    ),
    CategoryData(
      label: 'Car',
      value: 700,
      color: Colors.red,
      icon: Icons.directions_car_outlined,
    ),
    CategoryData(
      label: 'Entertainment',
      value: 550,
      color: Colors.pink,
      icon: Icons.celebration_outlined,
    ),
    CategoryData(
      label: 'Sports',
      value: 390,
      color: Colors.black,
      icon: Icons.sports_basketball_outlined,
    ),
    CategoryData(
      label: 'Food',
      value: 330,
      color: Colors.pink,
      icon: Icons.category_outlined,
    ),
  ];

  static const _chartTitles = AxisTitles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).surfaceContainer,
          borderRadius: const .all(
            .circular(24),
          ),
        ),
        child: Padding(
          padding: const .all(24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Spending Breakdown',
                style: TextTheme.of(context).titleSmall,
              ),
              const SizedBox(height: 34),
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: .spaceBetween,
                    maxY: _maxSpending,
                    minY: _minSpending,
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: _chartTitles,
                      rightTitles: _chartTitles,
                      leftTitles: _chartTitles,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final category = _categories[value.toInt()];

                            return Icon(
                              category.icon,
                              color: category.color,
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: _categories
                        .map(
                          (category) => BarChartGroupData(
                            x: _categories.indexOf(category),
                            barRods: [
                              _buildRodData(
                                value: category.value.toDouble(),
                                color: category.color,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartRodData _buildRodData({
    required final double value,
    final Color? color,
  }) {
    return BarChartRodData(
      toY: value,
      width: 24,
      borderRadius: const .vertical(top: Radius.circular(20)),
      color: color,
    );
  }
}

final class CategoryData {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const CategoryData({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
}
