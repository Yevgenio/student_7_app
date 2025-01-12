import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import '../../config.dart'; // Import AppTheme for styling

class SearchItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String itemType;
  final String itemId;

  const SearchItem({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.itemType,
    required this.itemId, // Default height
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String itemRoute = '';
        switch(itemType){
          case("chat"): 
            itemRoute = '/chatDetails';
            break;
          case("deal"): 
            itemRoute = '/dealDetails';
            break;
        }
        Navigator.pushNamed(
          context,
          itemRoute,
          arguments: itemId,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          margin: const EdgeInsets.only(left: 2),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            boxShadow: [AppTheme.primaryShadow],
            borderRadius: BorderRadius.circular(8),
          ),
            child: ListTile(
              leading:CachedImage(imagePath: imageUrl, width: 50, height: 50),
              title: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,),
              subtitle: Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,),
            ),
          ),

      ),
    );
  }
}
