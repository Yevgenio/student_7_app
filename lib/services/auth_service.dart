import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = '${Config.apiBaseUrl}/api/auth';
  final String uploadUrl = '${Config.apiBaseUrl}/api/uploads';

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

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Return JWT token
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
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
