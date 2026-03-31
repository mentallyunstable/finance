import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

final class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    const budgetItems = [
      _BudgetCategory(
        title: 'Dining & Food',
        subtitle: '8 days remaining',
        amount: '\$745 / \$800',
        badge: 'WARNING',
        progress: 0.93,
        accentColor: AppColors.error,
        icon: Icons.restaurant_rounded,
        highlighted: true,
      ),
      _BudgetCategory(
        title: 'Shopping',
        subtitle: 'Monthly cap: \$1,200',
        amount: '\$512 / \$1,200',
        badge: 'ON TRACK',
        progress: 0.42,
        accentColor: AppColors.primary,
        icon: Icons.shopping_bag_outlined,
      ),
      _BudgetCategory(
        title: 'Entertainment',
        subtitle: 'Overspent by \$42.00',
        amount: '\$342 / \$300',
        badge: 'EXCEEDED',
        progress: 1,
        accentColor: AppColors.error,
        icon: Icons.movie_creation_outlined,
        dangerStripe: true,
      ),
      _BudgetCategory(
        title: 'Transport',
        subtitle: 'Last month: \$380.00',
        amount: '\$280 / \$450',
        badge: 'ACTIVE',
        progress: 0.66,
        accentColor: Color(0xFF6B7280),
        icon: Icons.directions_bus_outlined,
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            AppColors.surfaceContainerLow,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 132),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1D3BF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Finance',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'OVERVIEW',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'Budgets',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Limit',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$4,250.00',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _PrimaryBudgetCard(
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Categories',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('Edit All')),
                ],
              ),
              const SizedBox(height: 20),
              for (final item in budgetItems) ...[
                _BudgetCategoryCard(
                  category: item,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 28),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF0052CC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(
                      'Create New Budget',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PrimaryBudgetCard extends StatelessWidget {
  const _PrimaryBudgetCard({
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1E),
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -34,
            right: -34,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Health',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You\'ve spent 64% of your total budget.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.auto_graph_rounded,
                    color: const Color(0xFF00714D),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Spent: \$2,720.00',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    '\$1,530.00 left',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: 0.64,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceContainer,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: const [
                  Expanded(
                    child: _MetricTile(label: 'DAILY LIMIT', value: '\$137.00'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _MetricTile(
                      label: 'PROJECTED\nSAVINGS',
                      value: '\$420.00',
                      highlighted: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFDDF7EB) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: highlighted ? const Color(0xFF00714D) : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: highlighted ? const Color(0xFF006C49) : null,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

final class _BudgetCategoryCard extends StatelessWidget {
  const _BudgetCategoryCard({
    required this.category,
    required this.textTheme,
    required this.colorScheme,
  });

  final _BudgetCategory category;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final stripe = category.dangerStripe ? Border(left: BorderSide(color: category.accentColor, width: 4)) : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: category.highlighted ? Border.all(color: category.accentColor.withValues(alpha: 0.12)) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x08191C1E),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: stripe,
        ),
        padding: EdgeInsets.fromLTRB(
          category.dangerStripe ? 20 : 18,
          18,
          18,
          18,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.accentColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: category.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: category.dangerStripe ? category.accentColor : colorScheme.onSurfaceVariant,
                          fontWeight: category.dangerStripe ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      category.amount,
                      style: textTheme.titleSmall?.copyWith(
                        color: category.highlighted || category.dangerStripe
                            ? category.accentColor
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.badge,
                      style: textTheme.labelSmall?.copyWith(
                        color: category.highlighted || category.dangerStripe
                            ? category.accentColor
                            : category.accentColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: category.progress,
                minHeight: 6,
                backgroundColor: AppColors.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(category.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _BudgetCategory {
  const _BudgetCategory({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.badge,
    required this.progress,
    required this.accentColor,
    required this.icon,
    this.highlighted = false,
    this.dangerStripe = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String badge;
  final double progress;
  final Color accentColor;
  final IconData icon;
  final bool highlighted;
  final bool dangerStripe;
}
