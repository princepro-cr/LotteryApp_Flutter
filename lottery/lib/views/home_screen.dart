import 'package:flutter/material.dart';
import 'pick_screen.dart';
import 'draw_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import '../core/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    PickScreen(),
    DrawScreen(),
    StatsScreen(),
    HistoryScreen(),
  ];

  final List<String> _titles = ['Pick', 'Draw', 'Stats', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: false,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.emerald,
        unselectedItemColor: AppColors.textSub,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Pick'),
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Draw'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}