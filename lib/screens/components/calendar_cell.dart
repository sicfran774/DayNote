import 'package:animations/animations.dart';
import 'package:day_note/spec/get_photo.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/photo_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'cell_image.dart';

const double width = 10;
const double height = 100;

final storageRef = FirebaseStorage.instance.ref();

class CalendarCell extends StatelessWidget {
  //final Function() notifyParent;
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
          future: GetPhoto.getPhoto(date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return cellBuilder(date, snapshot.data);
            } else {
              return const CircularProgressIndicator();
            }
          });
    } else {
      return const SizedBox(width: width, height: height);
    }
  }

  Widget cellBuilder(String date, File? displayImage) {
    return OpenContainer(
      closedBuilder: (context, action) =>
          CellImage(day: day, date: date, image: displayImage),
      openBuilder: (context, action) => PhotoDisplay(
        date: date,
        image: displayImage,
        //notifyParent: notifyParent(),
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
