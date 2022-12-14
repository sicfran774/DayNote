import 'package:flutter/cupertino.dart';
import 'package:outfit_tracker/screens/components/calendar_cell.dart';

class CalendarBuilder extends StatefulWidget {
  final int month;
  final int year;
  const CalendarBuilder({super.key, required this.year, required this.month});

  @override
  State<CalendarBuilder> createState() => _CalendarBuilderState();
}

class _CalendarBuilderState extends State<CalendarBuilder> {
  late int _currentDay;
  late DateTime _date;
  late int _daysInMonth;
  late int _startWeekday;

  @override
  Widget build(BuildContext context) {
    _currentDay = 1;
    _date = DateTime.utc(widget.year, widget.month, 1);
    _daysInMonth = DateTime.utc(_date.year, _date.month + 1, 0).day;
    _startWeekday = DateTime.utc(_date.year, _date.month, 1).weekday;

    List<TableRow> dayNameRow =
        List.generate(1, (index) => _generateDayNameRow(context));
    List<TableRow> tableRows = [...dayNameRow, ..._generateDayRows()];

    return Table(
      children: tableRows,
    );
  }

  List<TableRow> _generateDayRows() {
    return List.generate(
        _calculateNumWeeks(),
        (index) => TableRow(
            children: List.generate(
                7,
                (index) =>
                    CalendarCell(day: _currentDay, visible: isVisible()))));
  }

  TableRow _generateDayNameRow(BuildContext context) {
    return const TableRow(children: [
      Text("Sun"),
      Text("Mon"),
      Text("Tue"),
      Text("Wed"),
      Text("Thur"),
      Text("Fri"),
      Text("Sat")
    ]);
  }

  bool isVisible() {
    if (_startWeekday > 0 && _startWeekday != 7) {
      _startWeekday--;
      return false;
    } else {
      _currentDay++;
      return _currentDay <= _daysInMonth + 1;
    }
  }

  int _calculateNumWeeks() {
    if (_daysInMonth + _startWeekday - 1 >= 35 && _startWeekday != 7) {
      return 6;
    } else if (_daysInMonth + _startWeekday - 1 > 28) {
      return 5;
    } else {
      return 4;
    }
  }
}
