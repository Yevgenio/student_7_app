import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/chat_service.dart'; // Replace with your actual path

class ChatDetailsScreen extends StatefulWidget {
  final String chatId;

  ChatDetailsScreen({required this.chatId});

  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ChatService chatService = ChatService();
  Map<String, dynamic>? groupDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    try {
      final data = await chatService.fetchChatById(widget.chatId);
      setState(() {
        groupDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching group details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('פרטי הקבוצה'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : groupDetails != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Constrain the image size
                        if (groupDetails!['imagePath'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              groupDetails!['imagePath'],
                              fit: BoxFit.cover,
                              height: 200, // Set a maximum height
                              width: double.infinity,
                            ),
                          ),
                        SizedBox(height: 16), // Add spacing
                        Text(
                          groupDetails!['name'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          groupDetails!['description'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Category: ${groupDetails!['category'] ?? 'כללי'}',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            openWhatsApp(groupDetails!['link']);
                          },
                          child: Text('הצטרף לקבוצה'),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('Group not found')),
    );
  }

  void openWhatsApp(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }
}