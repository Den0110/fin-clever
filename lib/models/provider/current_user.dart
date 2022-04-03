import 'package:flutter/material.dart';
import '../app_user.dart';

class CurrentUser extends ChangeNotifier {
  AppUser? user;

  void updateUser(AppUser? user) {
    this.user = user;
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }
}
