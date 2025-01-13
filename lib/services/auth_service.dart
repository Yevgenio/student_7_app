import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final String baseUrl = '${ServerAPI.baseUrl}/api/auth';

  Future<void> signUp(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Map<String, String>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);

      await prefs.setString('token', data['token']);
      await prefs.setString('refreshToken', data['refreshToken']);

      return {'token': data['token'], 'refreshToken': data['refreshToken']};
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

void logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // Clear the tokens from SharedPreferences
  await prefs.remove('token');
  await prefs.remove('refreshToken');
  await prefs.remove('username'); // Optional if storing username

  // Sign out from Google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();

  // Navigate to the home screen or authentication screen
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
}


  Future<User> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
