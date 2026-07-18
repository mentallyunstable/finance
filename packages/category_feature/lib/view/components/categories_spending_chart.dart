import 'package:category_feature/data/category_data.dart';
import 'package:category_feature/data/default_categories_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final class CategoriesSpendingChart extends StatelessWidget {
  const CategoriesSpendingChart({super.key});

  final _maxSpending = 1000.0;
  final _minSpending = 0.0;

  static final _data = <MockChartCategoryData>[
    MockChartCategoryData(category: defaultCategoriesData[0], value: 1000),
    MockChartCategoryData(category: defaultCategoriesData[1], value: 750),
    MockChartCategoryData(category: defaultCategoriesData[2], value: 590),
    MockChartCategoryData(category: defaultCategoriesData[3], value: 299),
    MockChartCategoryData(category: defaultCategoriesData[4], value: 120),
  ];

  static const _chartTitles = AxisTitles();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainer,
        borderRadius: const .all(.circular(24)),
      ),
      child: Padding(
        padding: const .all(24),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Spending Breakdown', style: TextTheme.of(context).titleSmall),
            const SizedBox(height: 34),
            SizedBox(
              height: 220,
              width: double.infinity,
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
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: _buildBottomTitle),
                    ),
                  ),
                  barGroups: _data
                      .map(
                        (data) => BarChartGroupData(
                          x: _data.indexOf(data),
                          barRods: [_buildRodData(value: data.value.toDouble(), color: data.category.color)],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _data.length) {
      return const SizedBox.shrink();
    }

    final data = _data[index];

    return SideTitleWidget(
      meta: meta,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0),
      child: Icon(data.category.icon, color: data.category.color),
    );
  }

  BarChartRodData _buildRodData({required final double value, final Color? color}) {
    return BarChartRodData(
      toY: value,
      width: 24,
      borderRadius: const .vertical(top: Radius.circular(20)),
      color: color,
    );
  }
}

final class MockChartCategoryData {
  final CategoryData category;
  final int value;

  const MockChartCategoryData({required this.category, required this.value});
}
