import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../app_user.dart';

class CurrentUser extends ChangeNotifier {
  AppUser? user;
  final _userService = UserService();

  void updateUser(AppUser? user, {bool sendToServer = false}) {
    this.user = user;
    if (sendToServer && user != null) {
      _userService.updateUser(user);
    }
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }
}
