import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? _user;

  bool get loggedIn => _user != null;
  String? get user => _user;

  /// Mock login. Replace with real API integration.
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username.isNotEmpty && password == 'password') {
      _user = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
