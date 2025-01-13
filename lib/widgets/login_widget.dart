import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/services/auth_service.dart';
import '../../screens/user/user_profile_screen.dart';
import '../../screens/user/auth_selection_screen.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final AuthService authService = AuthService();

  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

Future<void> _fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refreshToken');
    //print('Access Token: ${prefs.getString('token')}');
    //print('Refresh Token: ${prefs.getString('refreshToken')}');
    if (token != null) {
      try {
        final user = await authService.fetchUserProfile(token);
        setState(() {
          username = user.username;
        });
      } catch (e) {
        if (refreshToken != null) {
          try {
            final newToken = await authService.refreshToken(refreshToken);
            await prefs.setString('token', newToken);
            final user = await authService.fetchUserProfile(newToken);
            setState(() {
              username = user.username;
            });
          } catch (refreshError) {
            logout();
          }
        } else {
          logout();
        }
      }
    }
  }

  void logout() async {
    authService.logout(context);
    setState(() {
      username = null;
    });
    //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (username == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AuthSelectionScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          username ?? 'התחבר/הרשם',
          style: AppTheme.p,
        ),
      ),
    );
  }
}
