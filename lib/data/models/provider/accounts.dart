import 'package:flutter/material.dart';
import '../account.dart';

class Accounts extends ChangeNotifier {
  List<Account> accounts = [];

  void updateAccounts(List<Account> accounts) {
    this.accounts = accounts;
    notifyListeners();
  }

  void clear() {
    accounts = [];
    notifyListeners();
  }
}
