import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';

import '../../services/chat_service.dart';
import '../../services/deal_service.dart';
import '../../services/auth_service.dart';

import '../deal/deal_query.dart';

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
  List<dynamic> chatGroups = [];
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
      final chatGroupsData = await chatService.fetchChats();
      final dealsData = await dealService.fetchDeals();
      setState(() {
        chatGroups = chatGroupsData;
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      username = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('עמוד הבית'),
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
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(token: token)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please log in to access your profile.')),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (username == null) ...[
                    Center(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            ),
                            child: const Text('Login'),
                          ),
                          SizedBox(width: AppTheme.itemPadding),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Welcome, $username!',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  Container(
                    height: 400, // Adjust height as needed
                    child: DealQuery(query: 'sort=recent&limit=10'),
                  ),
                ],
              ),
            ),
    );
  }
}
