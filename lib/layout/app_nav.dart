import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/screens/chat/chat_catalog.dart';
import 'package:student_7_app/screens/deal/deal_catalog.dart';

import '../screens/chat/chat_details_screen.dart';
import 'app_icons.dart';
import '../screens/chat/chat_screen.dart';

import '../screens/deal/deal_screen.dart';
import '../screens/deal/deal_details_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/user/user_profile_screen.dart';
import '../screens/search/search_screen.dart';

// import 'package:flutter/material.dart';
// import 'app_icons.dart';
// import '../screens/chat/chat_screen.dart';
// import '../screens/deal/deal_screen.dart';
// import '../screens/search/search_screen.dart';
// import '../screens/user/user_profile_screen.dart';

class AppNavbar extends StatelessWidget {
  final BuildContext context;
  final int selectedIndex;

  const AppNavbar({
    Key? key,
    required this.context,
    required this.selectedIndex,
  }) : super(key: key);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppTheme.cardColor,
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 1:
            _navigateTo(context, const ChatCatalog());
            break;
          case 2:
            _navigateTo(context, const DealCatalog());
            break;
          case 3:
            _navigateTo(context, const SearchScreen());
            break;
          case 4:
            _navigateTo(context, const ProfileScreen()); // Replace token if needed
            break;
        }
      },
      destinations: [
        NavigationDestination(
          selectedIcon: AppIcons.homeSolid(),
          icon: AppIcons.homeOutline(),
          label: 'בית',
        ),
        NavigationDestination(
          selectedIcon: AppIcons.groupSolid(),
          icon: AppIcons.groupOutline(),
          label: 'קבוצות',
        ),
        NavigationDestination(
          selectedIcon: AppIcons.dealsSolid(),
          icon: AppIcons.dealsOutline(),
          label: 'הטבות',
        ),
        NavigationDestination(
          selectedIcon: AppIcons.searchSolid(),
          icon: AppIcons.searchOutline(),
          label: 'חיפוש',
        ),
        NavigationDestination(
          selectedIcon: AppIcons.profileSolid(),
          icon: AppIcons.profileOutline(),
          label: 'פרופיל',
        ),
      ],
    );
  }
}
