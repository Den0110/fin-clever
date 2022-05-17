import 'package:fin_clever/data/models/operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

Future<void> showSelectDateDialog(BuildContext context) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015, 8),
    lastDate: DateTime.now(),
  );
  if (selectedDate != null) {
    context.read<Operation>().selectDate(selectedDate);
  }
}
