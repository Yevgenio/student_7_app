import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  Future<void> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? refreshToken = prefs.getString('refreshToken');

    if (token != null) {
      try {
        _user = await _authService.fetchUserProfile(token);
        notifyListeners();
      } catch (e) {
        if (refreshToken != null) {
          try {
            // Try refreshing the token if it's expired
            final newToken = await _authService.refreshToken(refreshToken);
            await prefs.setString('token', newToken);
            _user = await _authService.fetchUserProfile(newToken);
            notifyListeners();
          } catch (refreshError) {
            // If refreshing fails, log out
            await logout();
          }
        } else {
          await logout();
        }
      }
    } else {
      await logout();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}