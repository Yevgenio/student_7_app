class User {
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
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'] ?? 'default',
      role: json['role'] ?? 'user',
    );
  }
}
