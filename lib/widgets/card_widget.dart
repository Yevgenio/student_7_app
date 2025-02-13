import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import '../config.dart'; // Import AppTheme for styling

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String itemId;
  final double width; // Allow customization if needed
  final double height;
  final String navigatorRoute;

  const CardWidget({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.itemId,
    this.width = 250, // Default width
    this.height = 212, // Default height
    required this.navigatorRoute,
    //    this.width = 250, // Default width
    //    this.height = 400, // Default height
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          navigatorRoute,
          arguments: itemId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              boxShadow: const [AppTheme.primaryShadow],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section: Image
                  Expanded(
                    child: CachedImage(
                      imagePath: imageUrl,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  // Bottom Section: Text
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Deal Name
                        Text(
                          name,
                          style: AppTheme.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        // Deal Description
                        Text(
                          description,
                          style: AppTheme.p,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
