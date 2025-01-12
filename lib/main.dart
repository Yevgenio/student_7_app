import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:student_7_app/routes/routes.dart'; // Import the routes file
import 'package:student_7_app/layout/app_nav.dart';
import 'config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize plugins
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student 7',
      theme: AppTheme.themeData,
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
      // home: const AppLayout(),
      // routes: appRoutes,
      initialRoute: '/',
      routes: appRoutes
    );
  }
}
