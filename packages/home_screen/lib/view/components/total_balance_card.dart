import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

final class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const .all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 50,
            spreadRadius: -12,
            offset: const Offset(0, 25),
            color: Colors.black.withValues(alpha: 0.25),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFF003D9B),
            Color(0xFF0052CC),
          ],
        ),
      ),
      child: Padding(
        padding: const .all(32),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'TOTAL BALANCE',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$42,580.00',
              maxLines: 1,
              style: textTheme.displayMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Divider(
              color: Colors.white.withValues(alpha: 0.1),
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Monthly Spending',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$3,240.50',
                      style: textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .end,
                  children: [
                    Text(
                      'Savings Rate',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+12.4%',
                      style: textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).extension<AppColorsExtension>()?.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
