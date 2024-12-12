import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home/home_screen.dart'; 
import 'screens/layout.dart'; 
import 'screens/user/user_signup_screen.dart';
import 'screens/user/user_login_screen.dart';
import 'screens/user/user_profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize plugins
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue,
                        scaffoldBackgroundColor: Color(0xFFF8F8F8)),// #F8F8F8
      // Set Hebrew Locale and Directionality
      locale: const Locale('he'),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('he', ''), // Hebrew
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AppLayout(),
    );
  }
}
