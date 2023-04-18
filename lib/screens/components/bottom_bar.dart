import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/components/calendar/calendar.dart';
import 'package:day_note/screens/components/album/album.dart';

import '../home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 1;

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const CalendarScreen(),
    const AlbumScreen(),
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
          backgroundColor: Colors.blueGrey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: gitHubBlack,
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
                icon: Icon(Icons.photo_camera_back_outlined),
                label: "Albums",
                activeIcon: Icon(Icons.photo_camera_back_rounded)),
          ],
        ));
  }
}
