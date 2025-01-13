import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';

import '../../services/auth_service.dart';

import '../user/user_login_screen.dart';
import '../user/user_signup_screen.dart';
import '../user/user_profile_screen.dart';

class HomeMemo extends StatefulWidget {
  const HomeMemo({Key? key}) : super(key: key);

  @override
  _HomeMemoState createState() => _HomeMemoState();
}

class _HomeMemoState extends State<HomeMemo> {
  final AuthService authService = AuthService();
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              color: AppTheme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: username == null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ברוכים הבאים, שמחים שבאת!',
                              style: AppTheme.h2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  ),
                                  icon: const Icon(Icons.login),
                                  label: const Text('Login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.cardColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()),
                                  ),
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Sign Up'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.cardColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'שלום, $username!',
                                style: AppTheme.h2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()),
                                  );
                                },
                                icon: const Icon(Icons.account_circle),
                                label: const Text('Go to Profile'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        )),
            )),
      ),
    );
  }
}
