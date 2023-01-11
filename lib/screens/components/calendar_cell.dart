import 'package:flutter/material.dart';
import 'package:outfit_tracker/screens/photo_display.dart';

const double width = 10;
const double height = 100;

class CalendarCell extends StatelessWidget {
  final int day;
  final bool visible;

  const CalendarCell({super.key, required this.day, required this.visible});
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/images/saul.jpg');
    if (visible) {
      return GestureDetector(
        onTap: () => Navigator.push(
            //if cell is tapped, show preview
            context,
            MaterialPageRoute(
                builder: (context) => PhotoDisplay(assetImage: assetImage))),
        child: Container(
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
            child: Text(" ${day.toString()}")),
      );
    } else {
      return const SizedBox(width: width, height: height);
    }
  }
}
