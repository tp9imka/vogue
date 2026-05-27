import 'package:flutter/material.dart';

import 'browse/browse_screen.dart';
import 'log/history_screen.dart';
import 'today/today_screen.dart';

/// The app's home: a bottom-nav shell over Today, Browse and History.
class HomeShell extends StatefulWidget {
  /// Creates a [HomeShell].
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [TodayScreen(), BrowseScreen(), HistoryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
