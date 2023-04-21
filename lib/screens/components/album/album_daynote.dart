// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/screens/components/calendar/calendar.dart';
import 'package:day_note/spec/get_file.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';

class AlbumDayNote extends StatefulWidget {
  const AlbumDayNote(
      {super.key, required this.dayNoteList, required this.albumIndex});
  final List<String> dayNoteList;
  final int albumIndex;

  @override
  State<AlbumDayNote> createState() => _AlbumDayNoteState();
}

class _AlbumDayNoteState extends State<AlbumDayNote> {
  late List<String> dayNoteList = widget.dayNoteList;
  late int albumIndex = widget.albumIndex;
  int currentPage = 0;

  void removeFromAlbum() async {
    dayNoteList.removeAt(currentPage);
    var albums = await GetFile.readAlbumJson();
    albums[albumIndex].dayNotes = dayNoteList;
    GetFile.loadAlbums().writeAsString(jsonEncode(albums));
    setState(() {
      print("removed page $currentPage");
    });
  }

  @override
  Widget build(BuildContext context) {
    String date = "";
    //TODO: Make this better this code sucks
    try {
      date = dayNoteList[0];
    } catch (e) {}

    final PageController horizontalController = PageController();
    final ValueNotifier<String> dateNotifier = ValueNotifier(date);

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            return Text(
                value); //TODO: parse value so that it reflects date (Month Day, Year)
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
          dateNotifier.value = dayNoteList[index];
        },
      ),
      floatingActionButton: (dayNoteList.isNotEmpty)
          ? FloatingActionButton(
              onPressed: () => optionsWidget(currentPage),
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

  Future optionsWidget(int index) {
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
                removeFromAlbum();
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
