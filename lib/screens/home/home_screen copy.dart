import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/layout/app_drawer.dart';
import 'package:student_7_app/layout/app_nav.dart';
import 'package:student_7_app/screens/chat/chat_screen.dart';
import '../../layout/app_bar.dart';

import '../../services/chat_service.dart';
import '../../services/deal_service.dart';
import '../../services/auth_service.dart';

import '../deal/deal_query.dart';
import '../chat/chat_query.dart';

import '../user/user_login_screen.dart';
import '../user/user_signup_screen.dart';
import '../user/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService chatService = ChatService();
  final DealService dealService = DealService();
  final AuthService authService = AuthService();

  String? username;
  List<dynamic> chats = [];
  List<dynamic> deals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchData();
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

  Future<void> fetchData() async {
    try {
      final chatData = await chatService.fetchChats();
      final dealsData = await dealService.fetchDeals();
      setState(() {
        chats = chatData;
        deals = dealsData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
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
      appBar: CustomAppBar(
        title: 'סטודנט 7',
        actions: [
          if (username == null)
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
              child: const Text('התחבר', style: AppTheme.label),
            )
          else
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token =
                    prefs.getString('token'); // Retrieve the saved token
                if (token != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }
              },
              child: const Text('פרופיל', style: AppTheme.label),
            ),
          if (username != null)
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Login/Signup or Welcome Section
                Padding(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
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
                                              builder: (context) =>
                                                  SignUpScreen()),
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
                                              builder: (context) =>
                                                  ProfileScreen()),
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
                  ),
                ),
                const SizedBox(height: 16),

                // Chat Section
                const SizedBox(height: 8),
                ChatQuery(title: 'קבוצות חדשות', query: 'sort=recent&limit=10'),

                const SizedBox(height: 16),

                // Deal Section
                const SizedBox(height: 8),
                DealQuery(title: 'הטבות חדשות', query: 'sort=recent&limit=10'),
              ],
            )),
      bottomNavigationBar: AppNavbar(context: context, selectedIndex: 0),
    );
  }
}


