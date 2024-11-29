import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import 'chat_group_detail_screen.dart';

class ChatGroupsScreen extends StatefulWidget {
  @override
  _ChatGroupsScreenState createState() => _ChatGroupsScreenState();
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  final ChatService chatService = ChatService();
  List<dynamic> chatGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatGroups();
  }

  Future<void> fetchChatGroups() async {
    try {
      final data = await chatService.fetchChats();
      setState(() {
        chatGroups = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chat groups: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('קבוצות ווצאפ'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatGroups.length,
              itemBuilder: (context, index) {
                final group = chatGroups[index];
                return Card(
                  child: ListTile(
                    leading: group['imageUrl'] != null
                        ? Image.network(group['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.group),
                    title: Text(group['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group['description'] ?? 'No description available'),
                        Text('Category: ${group['category'] ?? 'General'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatGroupDetailsScreen(groupId: group['_id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}