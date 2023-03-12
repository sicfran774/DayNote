import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var date = DateFormat.yMMMM().format(DateTime.now()).toString();
final int year = DateTime.now().year;

class CalendarBar extends StatelessWidget {
  final String date;
  const CalendarBar({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 375,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(118, 158, 158, 158),
            offset: Offset(
              0,
              2.0,
            ),
            blurRadius: 5,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              //Todo: goto month display
              //onTap: () => changePage(oldIndex - 1),
              child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.chevron_left, color: Colors.white))),
          Text(date, style: headerMedium),
          const SizedBox(width: 50, height: 20)
        ],
      ),
    );
    /*  */
  }
}
