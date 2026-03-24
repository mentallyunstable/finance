import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell shell;

  const HomeScreen({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        items: const [,
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
