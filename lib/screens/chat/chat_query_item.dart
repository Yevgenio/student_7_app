import 'package:flutter/material.dart';
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
    this.height = 100, // Default height
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("chat tapped");
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Image
              // ClipRRect(
              //   borderRadius: const BorderRadius.all(Radius.circular(8)),
              //   child: CachedImage(
              //     imageUrl: imageUrl,
              //     height: 50,
              //     width: 50,
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) => Container(
              //       height: 50,
              //       color: Colors.grey[300],
              //       child: const Center(
              //           child: Icon(Icons.image, color: Colors.grey)),
              //     ),
              //   ),
              // ),
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
                        // maxLines: 1,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      // Chat Description
                      // Text(
                      //   description,
                      //   style: AppTheme.p,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 1,
                      // ),
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
