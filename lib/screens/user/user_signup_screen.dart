import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  String username = '';
  String email = '';
  String password = '';
  bool isLoading = false;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await authService.signUp(username, email, password);
        final tokenMap = await authService.login(email, password);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', tokenMap['token']!);
        await prefs.setString('refreshToken', tokenMap['refreshToken']!);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
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
      appBar: AppBar(title: Text('הרשמה')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'שם'),
                onChanged: (value) => username = value,
                validator: (value) =>
                    value!.isEmpty ? 'נא להזין שם' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'אימייל'),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'נא להזין אימייל' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'סיסמה'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) =>
                    value!.length < 6 ? 'יש להזין לפחות 6 תווים' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: Text('הרשמה'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
