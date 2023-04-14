import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarBar extends StatelessWidget {
  final String date;
  final ValueNotifier<bool> monthPageNotifier;
  final ValueNotifier<String> dateNotifier;
  final PageController dayPageController;
  final int currentYear;
  const CalendarBar(
      {super.key,
      required this.date,
      required this.monthPageNotifier,
      required this.dateNotifier,
      required this.dayPageController,
      required this.currentYear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 375,
      decoration: BoxDecoration(
        color: primaryAppColor,
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
      child: ValueListenableBuilder(
          valueListenable: monthPageNotifier,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: (!monthPageNotifier.value)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (!monthPageNotifier.value) ...[
                  IconButton(
                      onPressed: () {
                        dayPageController.jumpToPage(4000);
                        monthPageNotifier.value = true;
                        dateNotifier.value =
                            DateFormat.y().format(DateTime.now()).toString();
                      },
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: Colors.white),
                ],
                Text(date, style: headerMedium),
                if (!monthPageNotifier.value) ...[
                  const SizedBox(width: 50, height: 20)
                ]
              ],
            );
          }),
    );
  }
}
