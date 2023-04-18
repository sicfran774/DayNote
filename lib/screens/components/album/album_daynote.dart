import 'dart:io';

import 'package:day_note/spec/get_file.dart';
import 'package:flutter/material.dart';

class AlbumDayNote extends StatelessWidget {
  const AlbumDayNote({super.key, required this.dayNoteList});
  final List<String> dayNoteList;

  @override
  Widget build(BuildContext context) {
    PageController horizontalController = PageController();
    return Scaffold(
        appBar: AppBar(),
        body: PageView(
          controller: horizontalController,
          children: [
            for (String dayNote in dayNoteList) ...[
              individualDayNote(
                  dayNote.split('/')[0], int.parse(dayNote.split('/')[1]))
            ]
          ],
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
