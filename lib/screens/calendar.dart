import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_note/spec/text_styles.dart';
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

  void changePage(int index) {
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    //changeDate(month);

    return PageView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        return calendarPage(index);
      },
    );
  }

  Widget calendarPage(int oldIndex) {
    int index = oldIndex - 4000;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
      child: Column(children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  //Todo: goto month display
                  //onTap: () => changePage(oldIndex - 1),
                  child: const SizedBox(
                      width: 50, height: 50, child: Icon(Icons.chevron_left))),
              Text(
                  DateFormat.yMMMM()
                      .format(
                          DateTime.utc(year, month + index, DateTime.now().day))
                      .toString(),
                  style: headerMedium),
              const SizedBox(width: 50, height: 20)
            ],
          ),
        ),
        const SizedBox(height: 10),
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
