import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String user = '';
  logout() {
    this.user = '';
    notifyListeners();
  }

  void updateUser(String user) {
    this.user = user;
    notifyListeners();
  }
}
