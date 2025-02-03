import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
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
  Map<String, String> userdata = {};
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
        userdata = await authService.login(context, email, password);
              // In login flow (where you handle successful login)

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
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon:
                        Icon(Icons.email, color: AppTheme.secondaryColor),
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppTheme.secondaryColor),
                    ),
                  ),
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? 'נא להזין אימייל' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'סיסמה',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon:
                        Icon(Icons.key, color: AppTheme.secondaryColor),
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppTheme.secondaryColor),
                    ),
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
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.itemPadding),
        child: Text("התחברות", style: TextStyle(color: AppTheme.cardColor
        )),
      ),
      
      onPressed: () {
        login();
      },
    );
  }
}