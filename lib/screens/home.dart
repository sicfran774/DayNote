import 'package:day_note/screens/settings.dart';
import 'package:flutter/material.dart';

import '../spec/get_file.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text("DayNote"),
          actions: [
            IconButton(
                tooltip: "Settings",
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen())),
                icon: const Icon(Icons.settings))
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: [],
          ),
        ),
      ],
    ));
  }
}
