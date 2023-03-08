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
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Row(
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
          ),
          const SizedBox(height: 10),
          _dayRow(),
          SizedBox(
            height: 500,
            child: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: CalendarBuilder(year: year, month: month))),
            ]),
          )
        ]),
      ),
    );
  }

  Table _dayRow() {
    return Table(
        children: [...List.generate(1, (index) => _generateDayNameRow())]);
  }

  TableRow _generateDayNameRow() {
    return TableRow(children: [
      _dayText("Sun"),
      _dayText("Mon"),
      _dayText("Tue"),
      _dayText("Wed"),
      _dayText("Thur"),
      _dayText("Fri"),
      _dayText("Sat")
    ]);
  }

  Text _dayText(String day) {
    return Text(
      day,
      textAlign: TextAlign.center,
      style: dayStyle,
    );
  }
}
