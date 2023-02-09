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
      month = m;
      date = DateFormat.yMMMM()
          .format(DateTime.utc(year, month, DateTime.now().day))
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
