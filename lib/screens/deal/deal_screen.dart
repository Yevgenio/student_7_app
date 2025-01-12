import 'package:flutter/material.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'deal_catalog.dart';
import 'deal_details_screen.dart';

class DealScreen extends StatelessWidget {

  const DealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "הטבות",),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/dealDetails') {
            final dealId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => DealDetailsScreen(dealId: dealId),
            );
          }
      
          return MaterialPageRoute(
            builder: (context) => DealCatalog(),
          );
        },
      ),
    );
  }
}
