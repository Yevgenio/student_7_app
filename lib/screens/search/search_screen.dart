import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('חיפוש'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: const Center(
        child: Text(
          'לכל ההטבות',
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Color(0xFF39A7EE),
          fontSize: 14,
          fontFamily: 'Assistant',
          fontWeight: FontWeight.w600,
          height: 0,
          ),
        ),
      ),
      
    );
  }
}
