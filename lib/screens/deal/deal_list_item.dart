import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import '../../config.dart'; // Import AppTheme for styling

class DealListItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String dealId;
  final double width; // Allow customization if needed
  final double height;

  const DealListItem({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.dealId,
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
          '/dealDetails',
          arguments: dealId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.width - 28,
            // margin: const EdgeInsets.only(left: 8),
            // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              boxShadow: [AppTheme.primaryShadow],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section: Image
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(0, 0, 0, 0),
                    child: ClipRRect(
                      // borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)),
                        child: CachedImage(
                          imagePath: imageUrl,
                          width: MediaQuery.of(context).size.width,
                          // fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
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
    );
  }
}
