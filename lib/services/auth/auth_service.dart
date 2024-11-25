// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService with ChangeNotifier {
  ParseUser? user;

  Future<bool> signUp(String username, String password, String email) async {
    user = ParseUser.createUser(username, password, email);

    final response = await user!.signUp();

    if (response.success) {
      notifyListeners();
      return true;
    } else {
      user = null;
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    user = ParseUser(username, password, null);

    final response = await user!.login();

    if (response.success) {
      // Associate installation with user
      final installation = await ParseInstallation.currentInstallation();
      installation.set('user', user);
      await installation.save();

      notifyListeners();
      return true;
    } else {
      user = null;
      return false;
    }
  }

  Future<void> logout() async {
    if (user != null) {
      await user!.logout();
      user = null;
      notifyListeners();
    }
  }

  bool get isAuthenticated => user != null;
}
