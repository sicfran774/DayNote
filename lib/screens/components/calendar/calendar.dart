import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_note/spec/text_styles.dart';

import '../../../spec/color_styles.dart';
import 'calendar_bar.dart';
import 'calendar_builder.dart';

var date = DateFormat.yMMMM().format(DateTime.now()).toString();
bool monthPage = false;
final int year = DateTime.now().year;
final int month = DateTime.now().month;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late int currentYear = DateTime.now().year,
      currentMonth = DateTime.now().month;
  bool today = false;
  final PageController dayPageController = PageController(initialPage: 4000);
  final PageController monthPageController = PageController(initialPage: 4000);
  final ValueNotifier<String> dateNotifier = ValueNotifier(date);
  final ValueNotifier<bool> monthPageNotifier = ValueNotifier(monthPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: dateNotifier,
                builder: (context, value, child) {
                  return CalendarBar(
                    date: value,
                    monthPageNotifier: monthPageNotifier,
                    dateNotifier: dateNotifier,
                    dayPageController: dayPageController,
                    currentYear: currentYear,
                  );
                }),
            ValueListenableBuilder(
                valueListenable: monthPageNotifier,
                builder: (context, value, child) {
                  return Expanded(
                    child:
                        (value) ? monthCalendarHelper() : dayCalendarHelper(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget monthCalendarHelper() {
    return PageView.builder(
      controller: monthPageController,
      allowImplicitScrolling: true,
      onPageChanged: ((index) {
        currentYear = DateTime.utc(index - 4000 + year, month, 1).year;
        setState(() {
          today = (currentYear == DateTime.now().year);
        });
        // print('current year: $currentYear');
        dateNotifier.value = currentYear.toString();
      }),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: [
            monthCell("Jan", 1),
            monthCell("Feb", 2),
            monthCell("Mar", 3),
            monthCell("Apr", 4),
            monthCell("May", 5),
            monthCell("June", 6),
            monthCell("July", 7),
            monthCell("Aug", 8),
            monthCell("Sept", 9),
            monthCell("Oct", 10),
            monthCell("Nov", 11),
            monthCell("Dec", 12),
          ],
        ),
      ),
    );
  }

  Widget monthCell(String month, int monthIndex) {
    today = (DateTime.now().year == currentYear &&
        DateTime.now().month == monthIndex);
    return ElevatedButton(
      onPressed: () {
        int tempPage = 4000 +
            (monthIndex - DateTime.now().month) +
            ((currentYear - DateTime.now().year) * 12);

        dateNotifier.value = DateFormat.yMMMM()
            .format(DateTime.utc(currentYear, monthIndex, 1))
            .toString();
        // '{ $currentYear';
        monthPageNotifier.value = false;
        monthPageController.animateToPage(tempPage,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn);
      },
      style: (!today)
          ? ElevatedButton.styleFrom(backgroundColor: cellColor)
          : ElevatedButton.styleFrom(backgroundColor: cellColor),
      child: Center(
        child: Text(month, style: (!today) ? headerMedium : headerMediumColor),
      ),
    );
  }

  Widget dayCalendarHelper() {
    return PageView.builder(
      controller: dayPageController,
      allowImplicitScrolling: true,
      onPageChanged: ((index) {
        currentYear = DateTime.utc(year, index - 4000 + month, 1).year;
        currentMonth = DateTime.utc(year, index - 4000 + month, 1).month;

        dateNotifier.value = DateFormat.yMMMM()
            .format(DateTime.utc(year, index - 4000 + month, 1))
            .toString();
      }),
      itemBuilder: (context, index) {
        return dayCalendarPage(index);
      },
    );
  }

  Widget dayCalendarPage(int oldIndex) {
    int index = oldIndex - 4000;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        _dayRow(),
        Expanded(
            child: SingleChildScrollView(
                child: CalendarBuilder(year: year, month: month + index))),
      ]),
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
