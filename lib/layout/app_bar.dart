import 'package:flutter/material.dart';

import '../config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    required this.title,
    this.leading,
    this.actions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: AppBar(
        title: Text(
          title,
          style: AppTheme.h2,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: AppTheme.cardColor,//AppTheme.cardColor,
        foregroundColor: AppTheme.primaryColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: leading,
        actions: actions,
        automaticallyImplyLeading: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}
