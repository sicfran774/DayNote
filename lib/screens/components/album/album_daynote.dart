// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/spec/get_file.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlbumDayNote extends StatefulWidget {
  const AlbumDayNote(
      {super.key,
      required this.dayNoteList,
      required this.albumIndex,
      required this.albumName,
      required this.update});
  final List<String> dayNoteList;
  final int albumIndex;
  final String albumName;
  final Function() update;

  @override
  State<AlbumDayNote> createState() => _AlbumDayNoteState();
}

class _AlbumDayNoteState extends State<AlbumDayNote> {
  late List<String> dayNoteList = widget.dayNoteList;
  late int albumIndex = widget.albumIndex;
  late String albumName = widget.albumName;
  int currentPage = 0;

  void confirmDelete(
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

  void removeFromAlbum() async {
    dayNoteList.removeAt(currentPage);
    var albums = await GetFile.readAlbumJson();
    albums[albumIndex].dayNotes = dayNoteList;
    GetFile.loadAlbums().writeAsString(jsonEncode(albums));
    setState(() {
      print("removed page $currentPage");
    });
  }

  String convertToUTC(String year, String month, String day) {
    return DateFormat.yMMMMd()
        .format(DateTime(int.parse(year), int.parse(month), int.parse(day)))
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    String date = "";

    if (dayNoteList.isNotEmpty) {
      date = dayNoteList[0].split('/')[0];
    }

    final PageController horizontalController = PageController();
    final ValueNotifier<String> dateNotifier = ValueNotifier(date);

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            List<String> tempDate = value.split('_');
            return (tempDate.length == 3)
                ? Text(convertToUTC(tempDate[0], tempDate[1], tempDate[2]))
                : const Text("");
          },
        ),
      ),
      body: PageView(
        controller: horizontalController,
        children: [
          for (String dayNote in dayNoteList) ...[
            individualDayNote(
                dayNote.split('/')[0], int.parse(dayNote.split('/')[1]))
          ],
          if (dayNoteList.isEmpty) ...[
            const Center(
              child: Text(
                "No DayNotes found :(\nAdd one from the calendar!",
                style: headerMedium,
              ),
            )
          ]
        ],
        onPageChanged: (index) {
          currentPage = index;
          dateNotifier.value = dayNoteList[index].split('/')[0];
        },
      ),
      floatingActionButton: (dayNoteList.isNotEmpty)
          ? FloatingActionButton(
              onPressed: () => photoOptionsWidget(currentPage),
              child: const Icon(Icons.settings),
            )
          : Container(),
    );
  }

  Widget individualDayNote(String date, int index) {
    File image = File(GetFile.path(date, "photo", index: index));
    return Row(
      children: [
        Expanded(
            child: InteractiveViewer(child: Image(image: FileImage(image)))),
      ],
    );
  }

  Future photoOptionsWidget(int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Set as album display'),
            onTap: () {
              //TODO: setAsDisplayDayNote(index);
              Navigator.pop(context);
            },
          ),
          ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Remove this DayNote from this album'),
              onTap: () {
                confirmDelete(context, "Delete DayNote",
                    "Are you sure you want to remove this DayNote from $albumName? This will not remove it from the calendar.",
                    () {
                  removeFromAlbum();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.update();
                });
              }),
          ListTile(
            leading: const Icon(Icons.photo_camera_back),
            title: const Text('Album options'),
            onTap: () {
              Navigator.pop(context);
              albumOptionsWidget();
            },
          ),
        ],
      ),
    );
  }

  Future albumOptionsWidget() {
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
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void getAlbumName() async {
    albumName = (await GetFile.readAlbumJson())[albumIndex].albumName;
  }
}
