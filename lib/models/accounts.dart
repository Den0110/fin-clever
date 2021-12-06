import 'package:fin_clever/models/account.dart';
import 'package:flutter/material.dart';

class Accounts extends ChangeNotifier {
  List<Account> accounts = [];

  void updateAccounts(List<Account> accounts) {
    this.accounts = accounts;
    notifyListeners();
  }
}
