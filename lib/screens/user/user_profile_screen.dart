import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/layout/app_nav.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();
  User? user;
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchTokenAndUserProfile();
  }

  Future<void> fetchTokenAndUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please log in to access your profile.')),
        );
        Navigator.pop(context);
        return;
      }

      final fetchedUser = await authService.fetchUserProfile(token!);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'פרופיל',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('אין מידע משתמש'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar Section
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              color:
                                  AppTheme.secondaryColor, // Background color
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(32),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.avatar),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Username Section
                      Text(
                        user!.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user!.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Role Section
                      if (user!.role == "admin")
                        Chip(
                          label: Text(
                            'Admin',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF39A7EE),
                        ),
                      const SizedBox(height: 20),
                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle Edit Profile
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF19276F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {
                                authService.logout();
                              },
                              icon: const Icon(Icons.logout,
                                  color: Color(0xFF19276F)),
                              label: const Text(
                                'Logout',
                                style: TextStyle(color: Color(0xFF19276F)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF19276F),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
      // bottomNavigationBar: AppNavbar(context: context, selectedIndex: 4),
    );
  }
}
