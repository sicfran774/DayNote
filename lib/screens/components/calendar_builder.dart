import 'package:flutter/cupertino.dart';
import 'package:outfit_tracker/screens/components/calendar_cell.dart';

class CalendarBuilder extends StatefulWidget {
  const CalendarBuilder({super.key});

  @override
  State<CalendarBuilder> createState() => _CalendarBuilderState();
}

class _CalendarBuilderState extends State<CalendarBuilder> {
  final DateTime _date = DateTime.now();
  late final int _daysInMonth = DateTime(_date.year, _date.month + 1, 0).day;

  late int _startWeekday = DateTime(_date.year, _date.month, 0).weekday;
  late int _currentDay = 1;

  @override
  Widget build(BuildContext context) {
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
    if (_startWeekday >= 0 && _startWeekday != 6) {
      _startWeekday--;
      return false;
    } else {
      ++_currentDay;
      return _currentDay <= _daysInMonth + 1;
    }
  }

  int _calculateNumWeeks() {
    if (_daysInMonth + _startWeekday - 1 >= 35 && _startWeekday != 6) {
      return 6;
    } else if (_daysInMonth + _startWeekday - 1 > 28) {
      return 5;
    } else {
      return 4;
    }
  }
}
