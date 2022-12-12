import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/calendar_builder.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    var date = DateFormat.yMMMM().format(DateTime.now()).toString();

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.chevron_left),
              Text(date),
              Icon(Icons.chevron_right)
            ],
          ),
          const SizedBox(height: 10),
          const CalendarBuilder(),
        ],
      ),
    ));
  }
}
