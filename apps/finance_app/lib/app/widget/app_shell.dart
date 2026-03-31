import 'dart:ui';

import 'package:finance_app/shared/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: shell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 20),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [colorScheme.primary, const Color(0xFF0052CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.32),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: InkResponse(
                onTap: () => _goToTransactionCreation(context),
                containedInkWell: true,
                highlightShape: BoxShape.circle,
                radius: 28,
                splashColor: Colors.white.withValues(alpha: 0.28),
                highlightColor: Colors.white.withValues(alpha: 0.14),
                child: const Center(
                  child: Icon(Icons.mic_none_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(
        currentIndex: shell.currentIndex,
        colorScheme: colorScheme,
        textTheme: textTheme,
        onSelect: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
      ),
    );
  }

  void _goToTransactionCreation(final BuildContext context) {
    GoRouter.of(context).pushCreateTransactionScreen();
  }
}

final class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.currentIndex,
    required this.colorScheme,
    required this.textTheme,
    required this.onSelect,
  });

  final int currentIndex;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: additionalBottomPadding),
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: _BottomNavigationItem(
                      label: 'Home',
                      icon: Icons.grid_view_rounded,
                      selected: currentIndex == 0,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () => onSelect(0),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavigationItem(
                      label: 'History',
                      icon: Icons.history_rounded,
                      selected: currentIndex == 1,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () => onSelect(1),
                    ),
                  ),
                  const SizedBox(
                    width: 72,
                    height: double.infinity,
                  ),
                  Expanded(
                    child: _BottomNavigationItem(
                      label: 'Budgets',
                      icon: Icons.account_balance_wallet_outlined,
                      selected: currentIndex == 2,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () => onSelect(2),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavigationItem(
                      label: 'Settings',
                      icon: Icons.settings_outlined,
                      selected: currentIndex == 3,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () => onSelect(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.circle,
        radius: 28,
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        highlightColor: colorScheme.primary.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: foregroundColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
