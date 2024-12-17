import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_icons.dart';

import 'chat/chat_list_screen.dart';
import 'deal/deal_list_screen.dart';
import 'home/home_screen.dart';
import 'user/user_profile_screen.dart';
import 'search/search_screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  // Pages corresponding to the navigation destinations
  final List<Widget> _pages = [
    HomeScreen(),
    ChatGroupsScreen(),
    DealsScreen(),
    SearchScreen(),
    ProfileScreen(token: ''),
  ];

  // Navigation destinations with custom SVG icons
  final List<NavigationDestination> _destinations = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set RTL for Hebrew support
      child: Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}
