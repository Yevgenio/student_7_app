import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/layout/app_nav.dart';
import 'package:student_7_app/providers/auth_provider.dart';
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.fetchUser().then((_) {
      if (authProvider.user == null) {
        // Redirect to login if no user is found after attempting to fetch
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

//   void _checkLoginState() {
//   if (username == null) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const AuthSelectionScreen()),
//     );
//   }
// }

  // Future<void> fetchTokenAndUserProfile() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     token = prefs.getString('token');

  //     if (token == null) {
  //       Navigator.pushReplacementNamed(context, '/login');
  //       return;
  //     }

  //     final fetchedUser = await authService.fetchUserProfile(token!);
  //     setState(() {
  //       user = fetchedUser;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     // Handle errors and redirect
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to load profile')),
  //     );
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  Future<void> handleEditProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final newSettings = {
        'username': 'Updated Username',
        'email': 'updatedemail@example.com',
        // Add other fields if needed
      };

      await authService.updateUserSettings(token, newSettings);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      // fetchTokenAndUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // authProvider.fetchUser();
    final user = authProvider.user;

    if (user == null) {
      // If user is still null after loading, show a fallback message
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated. Redirecting...'),
        ),
      );
    }

    return Scaffold(
        appBar: const CustomAppBar(
          title: 'פרופיל',
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header with background and avatar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            color: AppTheme.secondaryColor, // Background color
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
                      const Chip(
                        label: Text(
                          'אדמין',
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
                            label: const Text('עריכת פרופיל'),
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
                              authService.logout(context);
                            },
                            icon: const Icon(Icons.logout,
                                color: Color(0xFF19276F)),
                            label: const Text(
                              'התנתק',
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
              ));
  }
}
