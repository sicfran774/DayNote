import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/photo_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

const double width = 10;
const double height = 100;

final storageRef = FirebaseStorage.instance.ref();

class CalendarCell extends StatefulWidget {
  final int day, month, year;
  final bool visible;

  const CalendarCell(
      {super.key,
      required this.day,
      required this.month,
      required this.year,
      required this.visible});

  @override
  State<CalendarCell> createState() => _CalendarCellState();
}

class _CalendarCellState extends State<CalendarCell> {
  late final int _day = widget.day;
  late final int _month = widget.day;
  late final int _year = widget.day;
  late final bool _visible = widget.visible;

  @override
  Widget build(BuildContext context) {
    String date = "${_year}_${_month}_$_day";
    File? displayImage;

    /*void getPhoto() async {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(await downloadImage("2023_2_1"));

      setState(() {
        displayImage = file;
      });
    }*/

    if (_visible) {
      //getPhoto();
      return cellBuilder(date, displayImage);
    } else {
      return const SizedBox(width: width, height: height);
    }
  }

  Widget cellBuilder(String date, File? displayImage) {
    return OpenContainer(
      closedBuilder: (context, action) => cell(displayImage),
      openBuilder: (context, action) =>
          PhotoDisplay(date: date, image: displayImage),
    );
  }

  Widget cell(File? displayImage) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: imageWidget(displayImage),
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(" ${_day.toString()}"));
  }

  DecorationImage imageWidget(File? displayImage) {
    if (displayImage != null) {
      return DecorationImage(image: FileImage(displayImage), fit: BoxFit.fill);
    } else {
      return const DecorationImage(
          image: AssetImage('assets/images/saul.jpg'), fit: BoxFit.fill);
    }
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
