import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
    return
    // Scaffold(
      //appBar: AppBar(title: const Text('Login')),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
        //child: 
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'אימייל',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? 'נא להזין אימייל' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'סיסמה',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.isEmpty ? 'נא להזין סיסמה' : null,
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : _buildLoginButton()
            ],
          ),
     //   ),
    //  ),
      );
  }
  
  Widget _buildLoginButton() {
    return FittedBox(// width: double.infinity, height: 50, // Full-width button
      child: SignInButton(
        Buttons.Email,
        text: "התחברות",
        onPressed: () {
          login;
        },
      ),
    );
  }
}