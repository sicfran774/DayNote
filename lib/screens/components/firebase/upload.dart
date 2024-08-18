import 'package:day_note/spec/color_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  final String userId;

  const UploadScreen({super.key, required this.userId});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late final String userId = widget.userId;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text("Upload data"),
              textColor: white,
              iconColor: white,
              onTap: () => {}),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text("Sync from cloud"),
              textColor: white,
              iconColor: white,
              onTap: () => {}),
        ],
      ),
    );
  }
}
