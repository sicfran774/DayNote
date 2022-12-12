import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ));
  }
}
