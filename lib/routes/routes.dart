import 'package:flutter/material.dart';
import 'package:student_7_app/layout/shared_scaffold.dart';
import 'package:student_7_app/screens/chat/chat_details_screen.dart';
import 'package:student_7_app/screens/chat/chat_screen.dart';
import 'package:student_7_app/screens/deal/deal_details_screen.dart';
import 'package:student_7_app/screens/deal/deal_screen.dart';
import 'package:student_7_app/screens/home/home_screen.dart';
import 'package:student_7_app/screens/search/search_screen.dart';
import 'package:student_7_app/screens/user/auth_selection_screen.dart';
import 'package:student_7_app/screens/user/user_profile_screen.dart';
import 'package:student_7_app/screens/user/user_login_screen.dart';
import 'package:student_7_app/screens/user/user_signup_screen.dart';

// Define routes as a Map
Map<String, WidgetBuilder> appRoutes = {

  // '/profile': (context) => ProfileScreen(token: '',),
  // '/login': (context) => const LoginScreen(),
  '/signup': (context) => SignUpScreen(),
  '/login': (context) => const AuthSelectionScreen(),

  
  '/': (context) => const SharedScaffold(),
  '/home': (context) => const HomeScreen(),
  '/chat': (context) => const ChatScreen(),
  '/deals': (context) => const DealScreen(),
  '/search': (context) => const SearchScreen(),
  '/profile': (context) => const ProfileScreen(),
  
  '/dealDetails': (context) {
    final String dealId = ModalRoute.of(context)!.settings.arguments as String;
    return DealDetailsScreen(dealId: dealId);
  },

  '/chatDetails': (context) {
    final String chatId = ModalRoute.of(context)!.settings.arguments as String;
    return ChatDetailsScreen(chatId: chatId);
  },
};
