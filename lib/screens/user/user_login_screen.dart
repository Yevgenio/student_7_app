import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
// import '../home/home_screen.dart';
import '../../layout/app_nav.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  String email = '';
  String password = '';
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // final token = await authService.login(email, password);
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', token);
        await authService.login(email, password);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false, // Remove all previous routes
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text('Sign in with Google'),
                      onPressed: () async {
                        try {
                          final token = await authService.googleSignIn();
                          if (token != null) {
                            await authService.loginWithGoogle(token); // Send token to backend
                            Navigator.pushNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Google sign-in canceled')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                    ),

            ],
          ),
        ),
      ),
    );
  }
}