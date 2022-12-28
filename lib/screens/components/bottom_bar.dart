import 'package:flutter/material.dart';
import 'package:outfit_tracker/screens/calendar.dart';
import 'package:outfit_tracker/screens/stats.dart';

import '../home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const CalendarScreen(),
    const StatsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
                activeIcon: Icon(Icons.home)),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: "Calendar",
                activeIcon: Icon(Icons.calendar_month)),
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart_outlined),
                label: "Stats",
                activeIcon: Icon(Icons.stacked_line_chart)),
          ],
        ));
  }
}
