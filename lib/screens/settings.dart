import 'package:day_note/screens/onboarding.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onTap: () => {
                    aboutPage(context),
                  }),
          ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text("How to use this app"),
              textColor: white,
              iconColor: white,
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(
                                  newUser: false,
                                )))
                  }),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: const Icon(Icons.folder_delete_rounded),
            title: const Text("Delete All Data"),
            textColor: white,
            iconColor: white,
            onTap: () {
              confirmDeleteAllData(context);
            },
          ),
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

  void aboutPage(BuildContext context) {
    final Uri linkedInURL =
        Uri.parse('https://www.linkedin.com/in/francis-rodriguez-05543a206/');
    final Uri gitHubURL = Uri.parse('https://github.com/sicfran774');

    Widget close = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Close"));
    Widget linkedIn = TextButton(
        onPressed: () => _launchUrl(linkedInURL),
        child: const Text("LinkedIn"));
    Widget gitHub = TextButton(
        onPressed: () => _launchUrl(gitHubURL), child: const Text("GitHub"));

    AlertDialog about = AlertDialog(
      title: Text("DayNote v${GetFile.version}"),
      content: const Text(
          "Thank you for downloading this app! Created by Francis Rodriguez"),
      actions: [linkedIn, gitHub, close],
    );
    showDialog(context: context, builder: (context) => about);
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
