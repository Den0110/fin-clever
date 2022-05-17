import 'package:flutter/material.dart';
import '../operation.dart';

class Operations extends ChangeNotifier {
  List<Operation> operations = [];

  void updateOperations(List<Operation> operations) {
    this.operations = operations;
    notifyListeners();
  }

  void clear() {
    operations = [];
    notifyListeners();
  }
}
