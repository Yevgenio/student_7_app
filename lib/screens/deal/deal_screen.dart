import 'package:flutter/material.dart';
import 'deal_list.dart';
import 'deal_details_screen.dart';

class DealScreen extends StatelessWidget {
  final VoidCallback onBackToHome;

  const DealScreen({required this.onBackToHome, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/dealDetails') {
          final dealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DealDetailsScreen(dealId: dealId),
          );
        }

        return MaterialPageRoute(
          builder: (context) => DealList(onBackToHome: onBackToHome),
        );
      },
    );
  }
}
