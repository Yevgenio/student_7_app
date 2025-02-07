import 'package:flutter/material.dart';
import 'package:student_7_app/services/image_service.dart';

class MemoLandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final memo = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(memo['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: ImageService.getProcessedImageUrl(memo['imagePath']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Image.network(snapshot.data!, height: 150, fit: BoxFit.cover);
              },
            ),
            const SizedBox(height: 16),
            Text(memo['description'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to the final destination
              },
              child: const Text("Go to Item"),
            ),
          ],
        ),
      ),
    );
  }
}
