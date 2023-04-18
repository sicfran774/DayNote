import 'dart:io';

import 'package:day_note/spec/get_file.dart';
import 'package:flutter/material.dart';

class AlbumDayNote extends StatelessWidget {
  const AlbumDayNote({super.key, required this.dayNoteList});
  final List<String> dayNoteList;

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
              return Text(value);
            },
          ),
        ),
        body: PageView(
          controller: horizontalController,
          children: [
            for (String dayNote in dayNoteList) ...[
              individualDayNote(
                  dayNote.split('/')[0], int.parse(dayNote.split('/')[1]))
            ]
          ],
          onPageChanged: (index) {
            dateNotifier.value = dayNoteList[index];
          },
        ));
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
}
