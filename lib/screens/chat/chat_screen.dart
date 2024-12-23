import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import '../../config.dart';

import 'chat_catalog.dart';
import 'chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  final VoidCallback onBackToHome;

  const ChatScreen({required this.onBackToHome, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/chatDetails') {
          final chatId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ChatDetailsScreen(chatId: chatId),
          );
        }

        return MaterialPageRoute(
          builder: (context) => ChatList(onBackToHome: onBackToHome),
        );
      },
    );
  }
}
