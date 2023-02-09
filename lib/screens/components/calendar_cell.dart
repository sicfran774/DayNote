import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/photo_display.dart';
import 'package:firebase_storage/firebase_storage.dart';

const double width = 10;
const double height = 100;

final storageRef = FirebaseStorage.instance.ref();

class CalendarCell extends StatelessWidget {
  final int day, month, year;
  final bool visible;

  CalendarCell(
      {super.key,
      required this.day,
      required this.month,
      required this.year,
      required this.visible});
  final AssetImage assetImage = AssetImage('assets/images/saul.jpg');

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return cellBuilder(assetImage);
    } else {
      return const SizedBox(width: width, height: height);
    }
  }

  Widget cellBuilder(AssetImage assetImage) {
    String date = "${year}_${month}_$day";
    return OpenContainer(
      closedBuilder: (context, action) => cell(),
      openBuilder: (context, action) =>
          PhotoDisplay(date: date, assetImage: assetImage),
    );
  }

  Widget cell() {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetImage,
            fit: BoxFit.fill,
          ),
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(" ${day.toString()}"));
  }
}
