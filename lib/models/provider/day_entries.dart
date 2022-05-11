import 'package:fin_clever/widgets/day_of_operations_item.dart';
import 'package:flutter/material.dart';

class DayEntries extends ChangeNotifier {
  List<DayEntry> dayEntries = [];

  void updateDayEntries(List<DayEntry> dayEntries) {
    this.dayEntries = dayEntries;
    notifyListeners();
  }

  void clear() {
    dayEntries = [];
    notifyListeners();
  }
}
