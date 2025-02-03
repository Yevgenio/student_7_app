import 'package:flutter/material.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/screens/search/search_screen.dart';

class HomeSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        height: 50.0,
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.transparent),
          boxShadow: [AppTheme.primaryShadow],
        ),
        child: const Row(
          children: <Widget>[
            Icon(Icons.search, color: AppTheme.primaryColor),
            SizedBox(width: 8.0),
            Text(
              'חיפוש חופשי...',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
