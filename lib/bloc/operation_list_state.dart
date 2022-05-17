import 'package:fin_clever/bloc/day_entry.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class OperationListState {}

class OperationListInitial extends OperationListState {}

class OperationListLoadInProgress extends OperationListState {}

class OperationListLoadSuccess extends OperationListState {
  final List<DayEntry> dayEntries;
  final double withMe;
  final int thisMonth;

  OperationListLoadSuccess({required this.dayEntries, required this.withMe, required this.thisMonth});
}

class OperationListLoadError extends OperationListState {
  final Exception error;

  OperationListLoadError(this.error);
}

class OperationListNavToAddExpense extends OperationListState {}
class OperationListNavToAddIncome extends OperationListState {}
