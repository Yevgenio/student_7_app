import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:student_7_app/layout/shared_scaffold.dart';
import 'package:student_7_app/providers/auth_provider.dart';
import 'package:student_7_app/routes/routes.dart'; // Import the routes file
import 'config.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); // Initialize plugins
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..fetchUser()),  // Fetch user at app start
        // Add other providers here
      ],
      child: MyApp(),
    ),
  );
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
      initialRoute: '/',
      routes: appRoutes, // Include all defined app routes
    );
  }
}
