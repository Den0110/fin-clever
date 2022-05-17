import 'package:fin_clever/data/models/operation.dart';

class DayEntry {
  DateTime date;
  final List<Operation> operations;
  bool isFirstDayOfMonth = false;
  String? recommendation;

  DayEntry(this.date, this.operations);
}