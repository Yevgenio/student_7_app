import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import '../../services/chat_service.dart';
import 'chat_details_screen.dart';
import '../../config.dart';
import '../../layout/app_bar.dart';
import 'chat_item.dart';

class ChatList extends StatefulWidget {
  final VoidCallback onBackToHome;

  const ChatList({required this.onBackToHome, Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatService chatService = ChatService();
  Map<String, List<dynamic>> groupedChat = {}; // Groups by category
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChat();
  }

  Future<void> fetchChat() async {
    try {
      final data = await chatService.fetchChats();

      // Chat data by category
      Map<String, List<dynamic>> groupedData = {};
      for (var chat in data) {
        String category = (chat['category'] == null || chat['category'].trim().isEmpty)
            ? 'כללי'
            : chat['category'];

        if (!groupedData.containsKey(category)) {
          groupedData[category] = [];
        }
        groupedData[category]!.add(chat);
      }

      setState(() {
        groupedChat = groupedData;
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
      appBar: CustomAppBar(
        title: 'קבוצות',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToHome, 
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Accordion(
              scaleWhenAnimating: false, // Enables scaling animation
              maxOpenSections: 1, //how many open categories?
              headerBackgroundColor: AppTheme.cardColor,
              headerBackgroundColorOpened: AppTheme.cardColor,
              headerBorderColor: Colors.transparent, 
              headerBorderColorOpened: Colors.transparent, 
              contentBackgroundColor: Colors.transparent,
              contentBorderColor: Colors.transparent,
              contentHorizontalPadding: 0, // Remove horizontal padding
              contentVerticalPadding: 0, // Remove vertical padding

              headerPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: groupedChat.keys.map((category) {
                final groups = groupedChat[category]!;
                return AccordionSection(
                  isOpen: false,
                  header: Text(
                    category,
                    style: AppTheme.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ), rightIcon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF19276F)),
                  content: Column(
                    children: groups.map((chat) {
                      return ChatListItem(
                        title: chat['name'],
                        imagePath: chat['imagePath'] ?? 'default', // Fallback image
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatDetailsScreen(chatId: chat['_id']),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  leftIcon: const Icon(Icons.chat, color: Color(0xFF19276F)),
                );
              }).toList(),
            ),
    );
  }
}
