import 'package:flutter/material.dart';

class StyledListItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const StyledListItem({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(top: 8, left: 24, right: 8, bottom: 8),
        decoration: BoxDecoration(
          border: const Border(
            left: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFF8F8F8),
            ),
            top: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFF8F8F8),
            ),
            right: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFF8F8F8),
            ),
            bottom: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFFF8F8F8),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            // Image Section
            ClipOval(
              child: Image.network(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                
              ),
            ),
            const SizedBox(width: 16),
            // Title and Subtitle Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF39A7EE),
                      fontSize: 16,
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
