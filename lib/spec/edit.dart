// ignore_for_file: avoid_print

import 'package:day_note/spec/get_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Edit {
  static Future albumOptionsWidget(BuildContext context, int albumIndex,
      String albumName, Function() onDelete) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.pen),
            title: const Text("Rename this album"),
            onTap: () => {},
          ),
          ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete this album'),
              onTap: () {
                confirmDelete(context, "Delete Album",
                    "Are you sure you want to delete $albumName?", () {
                  GetFile.deleteAlbum(albumIndex);
                  print("Deleted album $albumName");
                  onDelete();
                });
              }),
        ],
      ),
    );
  }

  static void confirmDelete(
      BuildContext context, String msg1, String msg2, Function func) {
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget confirm =
        TextButton(onPressed: () => func(), child: const Text("Yes"));

    AlertDialog confirmation = AlertDialog(
      title: Text(msg1),
      content: Text(msg2),
      actions: [cancel, confirm],
    );

    showDialog(
        context: context, builder: (BuildContext context) => confirmation);
  }
}
