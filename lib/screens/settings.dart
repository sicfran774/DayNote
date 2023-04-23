import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';

import '../spec/get_file.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.accessibility_new),
              title: const Text("About"),
              textColor: white,
              iconColor: white,
              onTap: () => {}),
          ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text("How to use this app"),
              textColor: white,
              iconColor: white,
              onTap: () => {}),
          ListTile(
            leading: const Icon(Icons.folder_delete_rounded),
            title: const Text("Delete All Data"),
            textColor: white,
            iconColor: white,
            onTap: () {
              confirmDeleteAllData(context);
            },
          )
        ],
      ),
    );
  }

  void confirmDeleteAllData(BuildContext context) {
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget confirm = TextButton(
        onPressed: () {
          Navigator.pop(context);
          GetFile.deleteAllData(context);
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
}
