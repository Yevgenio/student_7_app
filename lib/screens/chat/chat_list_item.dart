import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import '../../config.dart'; // Import AppTheme for styling

class ChatListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String chatId;
  final double width; // Allow customization if needed
  final double height;

  const ChatListItem({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.chatId,
    this.width = 500, // Default width
    this.height = 250, // Default height
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chatDetails',
          arguments: chatId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            boxShadow: [AppTheme.primaryShadow],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedImage(
                  imagePath: imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Bottom Section: Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Chat Name
                      Text(
                        name,
                        style: AppTheme.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      // Chat Description
                      Text(
                        description,
                        style: AppTheme.p,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
