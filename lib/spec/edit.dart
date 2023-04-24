// ignore_for_file: avoid_print

import 'package:day_note/spec/get_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Edit {
  static String textField = "";

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

  static Future albumOptionsWidget(BuildContext context, int albumIndex,
      String albumName, Function() onConfirm) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.pen),
            title: const Text("Rename this album"),
            onTap: () => {
              nameAlbumDialog(context, "Rename Album",
                  "Type a name for the album: ", "Rename", () {
                GetFile.renameAlbum(albumIndex, textField);
                onConfirm();
              })
            },
          ),
          ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete this album'),
              onTap: () {
                confirmDelete(context, "Delete Album",
                    "Are you sure you want to delete $albumName?", () {
                  GetFile.deleteAlbum(albumIndex);
                  GetFile.showSnackBarAlert(
                      context, "Deleted album: $albumName");
                  onConfirm();
                });
              }),
        ],
      ),
    );
  }

  static void nameAlbumDialog(BuildContext context, String title,
      String directions, String confirmOption, Function() onConfirm) {
    textField = "";
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget create = TextButton(
        onPressed: () {
          if (textField.isNotEmpty && textField.length < 16) {
            onConfirm();
          } else {
            GetFile.showSnackBarAlert(
                context, "Album name must be between 1 and 14 characters");
          }
        },
        child: Text(confirmOption));

    AlertDialog confirmation = AlertDialog(
      title: Center(child: Text(title)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(directions),
            TextField(
              onChanged: (value) {
                textField = value;
              },
            ),
          ],
        ),
      ),
      actions: [cancel, create],
    );

    showDialog(
        context: context, builder: (BuildContext context) => confirmation);
  }
}
