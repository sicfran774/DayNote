import 'package:animations/animations.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/get_file.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/components/daynote/photo_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'cell_image.dart';

const double width = 10;
const double height = 100;

final storageRef = FirebaseStorage.instance.ref();

class CalendarCell extends StatelessWidget {
  final int day, month, year;
  final bool visible;

  const CalendarCell({
    super.key,
    required this.day,
    required this.month,
    required this.year,
    required this.visible,
  });
  //required this.notifyParent});

  @override
  Widget build(BuildContext context) {
    String date = "${year}_${month}_$day";

    /*void getPhoto() async {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(await downloadImage("2023_2_1"));

      setState(() {
        displayImage = file;
      });
    }*/

    if (visible) {
      return FutureBuilder(
          future: GetFile.getFile(date, 'photo'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return cellBuilder(date, snapshot.data);
            } else {
              return Container(
                width: width,
                height: height,
                color: cellColor,
              );
            }
          });
    } else {
      return const SizedBox(width: width, height: height);
    }
  }

  Widget cellBuilder(String date, File? displayImage) {
    bool today = (DateTime.now().day == day &&
        DateTime.now().month == month &&
        DateTime.now().year == year);
    return OpenContainer(
      closedBuilder: (context, action) => CellImage(
        day: day,
        date: date,
        today: today,
      ),
      openBuilder: (context, action) => PhotoDisplay(
        date: date,
        title: DateFormat.yMMMMd()
            .format(DateTime.utc(year, month, day))
            .toString(),
      ),
    );
  }

  /*Future downloadImage(String date) async {
    final imageRef = storageRef.child(date);
    try {
      print("Downloading image...");
      const oneMegabyte = 1024 * 1024;
      return await imageRef.getData(oneMegabyte);
    } on FirebaseException catch (e) {}
  }*/
}
