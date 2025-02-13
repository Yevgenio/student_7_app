import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import '../../config.dart'; // Import AppTheme for styling

class ChatQueryItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String chatId;
  final double width; // Allow customization if needed
  final double height;

  const ChatQueryItem({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.chatId,
    this.width = 200, // Default width
    this.height = 50, // Default height
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
            borderRadius: BorderRadius.circular(48),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,  // Ensures 1:1 ratio for perfect circle
                child: ClipOval(
                  child: CachedImage(
                    imagePath: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Text Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
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
