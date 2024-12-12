import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/chat_service.dart';
import '../../services/deal_service.dart';
import '../../services/auth_service.dart';
import '../user/user_login_screen.dart';
import '../user/user_signup_screen.dart';
import '../user/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
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

// Check login status and fetch user details
Future<void> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token != null) {
    try {
      final user = await authService.fetchUserProfile(token);
      setState(() {
        username = user.username; // Set the username to display
      });
    } catch (e) {
      print('Error fetching user profile: $e');
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
        title: const Text('Home'),
        actions: [
          if (username == null)
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            )
          else
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(token: '')),
              ),
              child: const Text('Profile', style: TextStyle(color: Colors.white)),
            ),
            Container(
              width: 24,
              height: 24,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: FlutterLogo(),
          ),
                      Container(
              width: 24,
              height: 24,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: FlutterLogo(),
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
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            ),
                            child: const Text('Login'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
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
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Chat Groups',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: chatGroups.length,
                        itemBuilder: (context, index) {
                          final group = chatGroups[index];
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Center(
                                child: Text(group['name']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Deals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deals.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        final deal = deals[index];
                        return Card(
                          child: Column(
                            children: [
                              if (deal['imagePath'] != null)
                                Image.network(deal['imagePath'], height: 100, fit: BoxFit.cover),
                              Text(
                                deal['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(deal['description'] ?? ''),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
