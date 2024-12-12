import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import '../../services/chat_service.dart';
import 'chat_details_screen.dart';
import '../../config.dart';
import 'StyledListItem.dart';

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
        String category = group['category'] ?? 'כללי';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF19276F)),
              iconSize: 24,
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back to the previous screen
              },
            ),
            const SizedBox(width: 8), // Spacing between the back button and title
            // Title
            const Text(
              'קבוצות',
              textAlign: TextAlign.center,
              style: AppTheme.h3
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chat, color: Color(0xFF19276F)),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Accordion(
              scaleWhenAnimating: false, // Enables scaling animation
              maxOpenSections: 1, //how many open categories?
              headerBackgroundColor: Colors.white,
              headerBackgroundColorOpened: Colors.white,
              headerBorderColor: Color(0x00FFFFFF), 
              headerBorderColorOpened: Color(0x00FFFFFF), 
              contentBackgroundColor: Color(0x00FFFFFF),
              contentBorderColor: Color(0x00FFFFFF),
              contentHorizontalPadding: 0, // Remove horizontal padding
              contentVerticalPadding: 0, // Remove vertical padding

              headerPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: groupedChatGroups.keys.map((category) {
                final groups = groupedChatGroups[category]!;
                return AccordionSection(
                  isOpen: false,
                  header: Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF19276F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ), rightIcon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF19276F)),
                  content: Column(
                    children: groups.map((group) {
                      return StyledListItem(
                        title: group['name'],
                        
                        imagePath: group['imagePath'] ??
                            'https://via.placeholder.com/150', // Fallback image
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
                  leftIcon: const Icon(Icons.group, color: Color(0xFF19276F)),
                );
              }).toList(),
            ),
    );
  }
}
