import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_note/spec/text_styles.dart';
import 'components/calendar_bar.dart';
import 'components/calendar_builder.dart';

var date = DateFormat.yMMMM().format(DateTime.now()).toString();
final int year = DateTime.now().year;
final int month = DateTime.now().month;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final PageController controller = PageController(initialPage: 4000);
  final ValueNotifier<String> _notifier = ValueNotifier(date);

  void changePage(int index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (context, value, child) {
                return CalendarBar(date: value);
              }),
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: ((index) {
                _notifier.value = DateFormat.yMMMM()
                    .format(DateTime.utc(
                        year, index - 4000 + month, DateTime.now().day))
                    .toString();
              }),
              itemBuilder: (context, index) {
                return calendarPage(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget calendarPage(int oldIndex) {
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
