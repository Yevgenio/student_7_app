import 'package:flutter/material.dart';
import '../../config.dart';
import 'chat_query_item.dart';
// import 'chat_list.dart'; // Import the new ChatCard file
import '../../services/chat_service.dart';

class ChatQuery extends StatefulWidget {
  final String title;
  final String query;

  const ChatQuery({required this.title, required this.query, Key? key}) : super(key: key);

  @override
  _ChatQueryState createState() => _ChatQueryState();
}

class _ChatQueryState extends State<ChatQuery> with AutomaticKeepAliveClientMixin  {
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
      final fetchedChats = await chatService.fetchChatsByQuery(widget.query);
      setState(() {
        chats = fetchedChats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
        return isLoading
        ? const Center(child: CircularProgressIndicator())
        : chats.isEmpty
            ? const Center(child: Text('אין קבוצות'))
            : Padding(
                padding: const EdgeInsets.all(AppTheme.itemPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: AppTheme.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.itemPadding),
                    // Horizontal Chats List
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          return ChatQueryItem(
                            imageUrl: chat['imagePath'] ?? 'default',
                            name: chat['name'] ?? 'New Chat',
                            description: chat['description'] ?? '',
                            chatId: chat['_id'],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
  
  @override
  bool get wantKeepAlive => true;
}
