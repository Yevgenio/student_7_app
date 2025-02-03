import 'package:flutter/material.dart';
import '../../layout/app_bar.dart';

import '../../services/chat_service.dart';
import 'chat_list_item.dart';

class ChatListScreen extends StatefulWidget {
  final String query;

  const ChatListScreen({required this.query, Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService chatService = ChatService();
  List<dynamic> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    try {
      final response = await chatService.fetchChatsByQuery(widget.query);
      setState(() {
        chats = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'כל ההטבות'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListItem(
                  imageUrl: chat['imagePath'] ?? 'default',
                  name: chat['name'] ?? 'New Chat',
                  description: chat['description'] ?? 'Student 7',
                  chatId: chat['_id'],
                );
              },
            ),
    );
  }
}
