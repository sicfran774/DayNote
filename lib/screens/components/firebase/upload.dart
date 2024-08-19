import 'dart:io';

import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/get_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadScreen extends StatefulWidget {
  final String userId;

  const UploadScreen({super.key, required this.userId});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late final String userId = widget.userId;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false, downloading = false;

  Future uploadData() async {
    if (!uploading) {
      loadingDialog(context);
      uploading = true;
      var userFiles = Directory(GetFile.appDir);
      List<FileSystemEntity> files = userFiles.listSync(recursive: true);

      for (var file in files) {
        if (file is File) {
          String filePath = file.path;
          List<String> paths = filePath.split("/");
          try {
            if (paths.contains("photos")) {
              await FirebaseStorage.instance
                  .ref(
                      "$userId/photos/${paths[paths.length - 2]}/${paths.last}")
                  .putFile(file);
              print("Uploaded PHOTO ${paths[paths.length - 2]}/${paths.last}");
            } else if (paths.contains("notes")) {
              await FirebaseStorage.instance
                  .ref("$userId/notes/${paths[paths.length - 2]}/${paths.last}")
                  .putFile(file);
              print("Uploaded NOTE ${paths[paths.length - 2]}/${paths.last}");
            } else if (paths.last == "album.json") {
              await FirebaseStorage.instance
                  .ref("$userId/${paths.last}")
                  .putFile(file);
              print("Uploaded albums: ${paths.last}");
            }
          } catch (e) {
            print("Failed to upload $filePath");
          }
        }
      }
      showSnackBarAlert("Data successfully uploaded to cloud!");
      uploading = false;
      leavePage();
    }
  }

  void leavePage() {
    Navigator.pop(context);
  }

  void showSnackBarAlert(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
    ));
  }

  void loadingDialog(BuildContext context) {
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Close"));

    AlertDialog about = AlertDialog(
      title: const Text("Uploading data to cloud"),
      content: const Row(
        children: [
          Flexible(
            child: Text(
                "This window will close automatically. Please wait a moment..."),
          ),
          SizedBox(width: 10),
          CircularProgressIndicator(),
        ],
      ),
      actions: [cancel],
    );
    showDialog(context: context, builder: (context) => about);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: Row(
                children: [
                  const Text("Upload data"),
                  if (uploading) ...[const CircularProgressIndicator()]
                ],
              ),
              textColor: white,
              iconColor: white,
              onTap: () => uploadData()),
          ListTile(
              leading: const Icon(Icons.download),
              title: Row(
                children: [
                  const Text("Sync from cloud"),
                  if (downloading) ...[const CircularProgressIndicator()]
                ],
              ),
              textColor: white,
              iconColor: white,
              onTap: () => {}),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sign out"),
              textColor: white,
              iconColor: white,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                leavePage();
              }),
        ],
      ),
    );
  }
}
