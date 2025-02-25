import '../config.dart';

class User {
  static const String uploadUrl = '${ServerAPI.baseUrl}/api/uploads';

  final String username;
  final String email;
  final String avatar;
  final String role;

  User({
    required this.username,
    required this.email,
    required this.avatar,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? 'Guest',
      email: json['email'] ?? 'N/A',
      avatar: json['avatar'] != null
          ? (json['avatar'].startsWith('http') ? json['avatar'] : '$uploadUrl/${json['avatar']}') // Check if avatar is a URL
          : '$uploadUrl/default', // Default placeholder
      role: json['role'] ?? 'user', // Default role is 'user'
    );
  }
}
