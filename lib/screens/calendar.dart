import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_note/spec/text_styles.dart';
import 'components/calendar_builder.dart';

var date = DateFormat.yMMMM().format(DateTime.now()).toString();

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;

  void changeDate(int m) {
    setState(() {
      if (m < 1) {
        month = 12;
        year -= 1;
      } else if (m > 12) {
        month = 1;
        year += 1;
      } else {
        month = m;
      }

      date = DateFormat.yMMMM()
          .format(DateTime.utc(year, month, DateTime.now().day))
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    changeDate(month);
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Right Swipe
          changeDate(month - 1);
        } else if (details.primaryVelocity! < 0) {
          //Left Swipe
          changeDate(month + 1);
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () => changeDate(month - 1),
                      child: const Icon(Icons.chevron_left)),
                  Text(date, style: headerMedium),
                  GestureDetector(
                      onTap: () => changeDate(month + 1),
                      child: const Icon(Icons.chevron_right))
                ],
              ),
              const SizedBox(height: 10),
              CalendarBuilder(year: year, month: month),
            ]),
          ),
        ),
      ),
    );
  }
}
