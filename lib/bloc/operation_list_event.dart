import 'package:flutter/foundation.dart';

@immutable
abstract class OperationListEvent {}

class OperationListDataLoadRequested extends OperationListEvent {}

class OperationListAddExpensePressed extends OperationListEvent {}

class OperationListAddIncomePressed extends OperationListEvent {}

class OperationListDeleteItemPressed extends OperationListEvent {
  final int operationId;

  OperationListDeleteItemPressed(this.operationId);
}
