import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/widgets/cached_image.dart';
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
  Map<String, dynamic>? chatDetails;
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
        chatDetails = data;
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
        appBar: const CustomAppBar(
          title: 'פרטי הקבוצה',
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : chatDetails != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Constrain the image size
                          if (chatDetails!['imagePath'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedImage(
                                imagePath: chatDetails!['imagePath'],
                                fit: BoxFit.cover,
                                height: 200, // Set a maximum height
                                width: double.infinity,
                              ),
                            ),
                          SizedBox(height: 16), // Add spacing
                          Text(
                            chatDetails!['name'],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          if (chatDetails!['category'] != null && chatDetails!['category']!.trim().isNotEmpty)
                            Chip(
                              label: Text(
                                chatDetails!['category'],
                                style: AppTheme.label,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                            ),
                          SizedBox(height: 8),
                          _buildDescription(chatDetails!['description'] ?? ''),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                openWhatsApp(chatDetails!['link']);
                              },
                              child: Text('הצטרף לקבוצה'),
                            ),
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


  Widget _buildDescription(String description) {
    // Regular expression to match URLs starting with http, https, or www
    final regex = RegExp(
        r'(https?:\/\/[^\s]+|www\.[^\s]+)',
        caseSensitive: false);

    final spans = <TextSpan>[];

    description.splitMapJoin(
      regex,
      onMatch: (match) {
        final url = match.group(0)!; // Extract the matched URL
        final displayText = url.startsWith('www') ? 'https://$url' : url; // Add scheme to "www" if missing
        spans.add(TextSpan(
          text: url,
          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(displayText);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                print('Could not launch $displayText');
              }
            },
        ));
        return '';
      },
      onNonMatch: (text) {
        spans.add(TextSpan(text: text, style: AppTheme.p));
        return '';
      },
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
