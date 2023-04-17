import 'package:flutter/material.dart';

import '../spec/get_file.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void confirmDeleteAllData() {
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget confirm = TextButton(
        onPressed: () {
          Navigator.pop(context);
          GetFile.deleteAllData();
        },
        child: const Text("Delete"));

    AlertDialog confirmation = AlertDialog(
      title: const Text("Are you sure you want to delete all data?"),
      content: const Text("This cannot be undone."),
      actions: [cancel, confirm],
    );

    showDialog(
        context: context, builder: (BuildContext context) => confirmation);
  }

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
                onPressed: () {
                  confirmDeleteAllData();
                },
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
