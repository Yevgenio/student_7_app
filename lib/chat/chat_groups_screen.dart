import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import '../services/chat_service.dart';
import 'chat_group_detail_screen.dart';

class ChatGroupsScreen extends StatefulWidget {
  @override
  _ChatGroupsScreenState createState() => _ChatGroupsScreenState();
}

class _ChatGroupsScreenState extends State<ChatGroupsScreen> {
  final ChatService chatService = ChatService();
  Map<String, List<dynamic>> groupedChatGroups = {}; // Groups by category
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChatGroups();
  }

  Future<void> fetchChatGroups() async {
    try {
      final data = await chatService.fetchChats();

      // Group data by category
      Map<String, List<dynamic>> groupedData = {};
      for (var group in data) {
        String category = group['category'] ?? 'General';
        if (!groupedData.containsKey(category)) {
          groupedData[category] = [];
        }
        groupedData[category]!.add(group);
      }

      setState(() {
        groupedChatGroups = groupedData;
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
          : Accordion(
              scaleWhenAnimating: false, // Enables scaling animation
              maxOpenSections: 1, //how many open categories?
              headerBackgroundColorOpened: Colors.blue,
              contentBackgroundColor: Colors.grey[200],
              contentBorderColor: Colors.blueGrey,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: groupedChatGroups.keys.map((category) {
                final groups = groupedChatGroups[category]!;
                return AccordionSection(
                  isOpen: false,
                  header: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    children: groups.map((group) {
                      return ListTile(
                        leading: group['imageUrl'] != null
                            ? Image.network(
                                group['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.group),
                        title: Text(group['name']),
                        subtitle: Text(group['description'] ??
                            'No description available'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatGroupDetailsScreen(groupId: group['_id']),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  leftIcon: const Icon(Icons.group, color: Colors.white),
                );
              }).toList(),
            ),
    );
  }
}
