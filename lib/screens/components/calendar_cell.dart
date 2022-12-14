import 'package:flutter/material.dart';

const double width = 50;
const double height = 75;

class CalendarCell extends StatelessWidget {
  final int day;
  final bool visible;

  const CalendarCell({super.key, required this.day, required this.visible});
  @override
  Widget build(BuildContext context) {
    if (visible) {
      return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(" ${day.toString()}"));
    } else {
      return const SizedBox(width: width, height: height);
    }
  }
}
