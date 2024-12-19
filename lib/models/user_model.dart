import '../config.dart';

class User {
  static const String uploadUrl = '${Config.apiBaseUrl}/api/uploads';

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
          ? '$uploadUrl/${json['avatar']}' // Construct full URL if avatar exists
          : '$uploadUrl/default', // Default placeholder
      role: json['role'] ?? 'user', // Default role is 'user'
    );
  }
}
