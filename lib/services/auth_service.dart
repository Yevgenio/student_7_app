import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/providers/auth_provider.dart';
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

  Future<Map<String, String>> login(BuildContext context, String email, String password) async {
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

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fetchUser(); // Trigger state update

      return {'username': data['username'], 'token': data['token'], 'refreshToken': data['refreshToken']};
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

void logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  // Clear the tokens from SharedPreferences
  // await prefs.remove('token');
  // await prefs.remove('refreshToken');
  // await prefs.remove('username'); // Optional if storing username

  // Sign out from Google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  authProvider.logout(); // This calls notifyListeners()

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

  Future<void> updateUserSettings(String token, Map<String, dynamic> settings) async {
    final url = Uri.parse('${ServerAPI.baseUrl}/api/user/settings');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(settings),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user settings');
    }
  }

  // Future<http.Response> secureApiRequest(Future<http.Response> Function(String token) apiCall, BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   String? refreshToken = prefs.getString('refreshToken');

  //   if (token == null || refreshToken == null) {
  //     Provider.of<AuthProvider>(context, listen: false).logout();
  //     throw Exception("User not authenticated.");
  //   }

  //   http.Response response = await apiCall(token);

  //   if (response.statusCode == 401) {
  //     // Try refreshing token
  //     try {
  //       final newToken = await refreshToken(refreshToken);
  //       await prefs.setString('token', newToken);

  //       // Retry the API call with new token
  //       response = await apiCall(newToken);
  //     } catch (e) {
  //       Provider.of<AuthProvider>(context, listen: false).logout();
  //       throw Exception("Session expired. Please log in again.");
  //     }
  //   }

  //   return response;
  // }
}
