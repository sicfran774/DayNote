import 'package:flutter/cupertino.dart';
import 'package:outfit_tracker/screens/components/calendar_cell.dart';

class CalendarBuilder extends StatefulWidget {
  const CalendarBuilder({super.key});

  @override
  State<CalendarBuilder> createState() => _CalendarBuilderState();
}

class _CalendarBuilderState extends State<CalendarBuilder> {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(5, (index) => generateDayRows(context)),
    );
  }

  TableRow generateDayRows(BuildContext context) {
    return TableRow(children: List.generate(7, (index) => CalendarCell()));
  }
}
