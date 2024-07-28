// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/screens/components/daynote/photo_display.dart';
import 'package:day_note/spec/get_file.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:day_note/spec/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
  late QuillController controller;
  late ScrollController scrollController;
  FocusNode focusNode = FocusNode();
  int currentPage = 0;

  void removeFromAlbum() async {
    dayNoteList.removeAt(currentPage);
    var albums = await GetFile.readAlbumJson();
    albums[albumIndex].dayNotes = dayNoteList;
    GetFile.saveAlbumJson(albums);

    setState(() {
      currentPage = 0;
      print("Removed page $currentPage from $albumName");
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
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            List<String> tempDate = value.split('_');
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    albumName,
                    style: headerLarge,
                  ),
                  if (tempDate.length == 3) ...[
                    Text(
                      convertToUTC(tempDate[0], tempDate[1], tempDate[2]),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ]);
          },
        ),
        actions: [
          if (date != "") ...[
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Why can't I edit anything?"),
                            content: const Text(
                                "You are currently in an album. To edit a DayNote, you can click on the cog below and go to that day on the calendar."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
                },
                icon: const Icon(Icons.question_mark_rounded))
          ]
        ],
      ),
      body: PageView(
        controller: horizontalController,
        children: [
          for (String dayNote in dayNoteList) ...[
            individualDayNote(
                dayNote.split('/')[0], int.parse(dayNote.split('/')[1]))
          ],
          if (dayNoteList.isEmpty) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No DayNotes found :(",
                  style: headerMedium,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, '/calendar');
                  },
                  child: const Text(
                    "Add one from the calendar!",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ]
        ],
        onPageChanged: (index) {
          currentPage = index;
          dateNotifier.value = dayNoteList[index].split('/')[0];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (dayNoteList.isNotEmpty)
            ? photoOptionsWidget(currentPage)
            : Edit.albumOptionsWidget(
                context, albumIndex, albumName, () => onDelete()),
        child: const Icon(Icons.settings),
      ),
    );
  }

  Widget individualDayNote(String date, int index) {
    return SingleChildScrollView(
      child: Column(
        children: [photoSection(date, index), noteSection(date, index)],
      ),
    );
  }

  Widget photoSection(String date, int index) {
    File image = File(GetFile.path(date, "photo", index: index));
    return Row(
      children: [
        Expanded(
            child: InteractiveViewer(child: Image(image: FileImage(image)))),
      ],
    );
  }

  Widget noteSection(String date, int index) {
    if (GetFile.exists(date, "note", index: index)) {
      controller = QuillController(
          document: Document.fromJson(jsonDecode(
              File(GetFile.path(date, "note", index: index))
                  .readAsStringSync())),
          selection: const TextSelection.collapsed(offset: 0));

      return Container(
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(width: 3, color: Colors.black),
          )),
          height: 500,
          child: quillEditor());
    } else {
      return Container();
    }
  }

  QuillEditor quillEditor() {
    ScrollController scrollController = ScrollController();
    return QuillEditor(
      configurations: QuillEditorConfigurations(
        controller: controller,
        scrollable: true,
        padding: const EdgeInsets.all(10),
        autoFocus: false,
        expands: true,
        customStyles: const DefaultStyles(
          paragraph: DefaultTextBlockStyle(
              TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
              HorizontalSpacing(16, 0),
              VerticalSpacing(0, 0),
              VerticalSpacing(0, 0),
              null),
        ),
      ),
      scrollController: scrollController,
      focusNode: focusNode,
    );
  }

  Future photoOptionsWidget(int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          if (index != 0) ...[
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Set as album display'),
              onTap: () {
                GetFile.moveAlbumDayNotePosition(albumIndex, index, 0);
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {
                  widget.update();
                });
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.arrow_circle_right),
            title: const Text("Go to this day on the calendar"),
            onTap: () {
              List<String> tempDate =
                  dayNoteList[index].split('/')[0].split('_');

              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calendar');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhotoDisplay(
                            date: dayNoteList[index].split('/')[0],
                            title: convertToUTC(
                                tempDate[0], tempDate[1], tempDate[2]),
                          )));
            },
          ),
          ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Remove this DayNote from this album'),
              onTap: () {
                Edit.confirmDelete(context, "Delete DayNote",
                    "Are you sure you want to remove this DayNote from $albumName? This will not remove it from the calendar.",
                    () {
                  removeFromAlbum();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  GetFile.showSnackBarAlert(
                      context, "Removed DayNote from $albumName");
                  widget.update();
                });
              }),
          ListTile(
            leading: const Icon(Icons.photo_camera_back),
            title: const Text('Album options'),
            onTap: () {
              Navigator.pop(context);
              Edit.albumOptionsWidget(
                  context, albumIndex, albumName, () => onDelete());
            },
          ),
        ],
      ),
    );
  }

  void onDelete() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    widget.update();
  }
}
