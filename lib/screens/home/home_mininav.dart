import 'package:flutter/material.dart';
import 'package:student_7_app/layout/app_icons.dart';
import 'package:student_7_app/screens/chat/chat_catalog.dart';
import 'package:student_7_app/screens/chat/chat_screen.dart';
import 'package:student_7_app/screens/deal/deal_catalog.dart';
import 'package:student_7_app/screens/deal/deal_screen.dart';
import 'package:student_7_app/config.dart';

class HomeMiniNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add screen padding
      child: Row(
        children: [
          // First Button
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardColor,
                foregroundColor: AppTheme.primaryColor,
                textStyle: AppTheme.h3,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatCatalog()),
                );
              },
              icon: AppIcons.groupOutline(),
              label: const Text(
                'קבוצות',
                overflow: TextOverflow.ellipsis, // Ellipsis for text overflow
                maxLines: 1, // Limit text to one line
              ),
            ),
          ),
          const SizedBox(width: 8.0), // Space between buttons
          // Second Button
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardColor,
                foregroundColor: AppTheme.primaryColor,
                textStyle: AppTheme.h3,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DealCatalog()),
                );
              },
              icon: AppIcons.dealsOutline(),
              label: const Text(
                'הטבות',
                overflow: TextOverflow.ellipsis, // Ellipsis for text overflow
                maxLines: 1, // Limit text to one line
              ),
            ),
          ),
        ],
      ),
    );
  }
}
