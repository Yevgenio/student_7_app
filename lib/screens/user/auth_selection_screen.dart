import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/providers/auth_provider.dart';
import '../../services/auth_service.dart';
import 'user_login_screen.dart';
import 'user_signup_screen.dart';

class AuthSelectionScreen extends StatefulWidget {
  const AuthSelectionScreen({Key? key}) : super(key: key);

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen> {
  bool _isLoading = false;

  Future<void> _loginWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId:
          '148902254409-nmmr59v0ubvjl1118hks8qu33a99c4a4.apps.googleusercontent.com', // Use your web client ID
    );
    setState(() {
      _isLoading = true;
    });

    try {
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw Exception('User canceled the login process');
      }

      final authentication = await account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null) {
        throw Exception('ID Token is null');
      }

      final response = await http.post(
        Uri.parse('${ServerAPI.baseUrl}/api/auth/google/android'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('refreshToken', data['refreshToken']);
        // After saving tokens:
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.fetchUser(); // Refresh user state

        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        throw Exception('Google login failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('כיצד תרצה להזדהות?')),
      body: SingleChildScrollView(
        child: Column(
          children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            _buildGoogleButton(),
            const SizedBox(
              height: AppTheme.sectionPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text('- או -'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.itemPadding),
              child: const LoginScreen(),
            ),
            const SizedBox(height: AppTheme.itemPadding),
            SizedBox(
              height: AppTheme.sectionPadding,
              child: TextButton(
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>
                    const SignUpScreen()),
              );
                },
                child: const Text('הרשמה עם מייל'),
              ),
            ),
              ],
            ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SignInButton(
      Buttons.Google,
      text: "כניסה באמצעות Google",
      onPressed: () {
        _loginWithGoogle(context);
      },
      
      // padding: const EdgeInsets.symmetric(vertical: 12),
      
    );
  }
  // return ElevatedButton.icon(
  //   onPressed: () => _loginWithGoogle(context),
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: Colors.white,
  //     foregroundColor: Colors.black,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //   ),
  //   icon: Image.asset('assets/google_logo.png', height: 24), // Add your Google logo asset
  //   label: const Text('התחברות עם גוגל'),
  // );
  //}
}
