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
      selectedIcon: SvgPicture.asset(
        'home.svg',
        width: 24,
        height: 24,
        color: Color(0xFF19276F),
      ),
      icon: AppIcons.homeOutline(size: 24, color: Color(0xFF19276F)),
      label: 'בית',
    ),
    NavigationDestination(
      selectedIcon: AppIcons.groupSolid(size: 24, color: Color(0xFF19276F)),
      icon: AppIcons.groupOutline(size: 24, color: Color(0xFF19276F)),
      label: 'קבוצות',
    ),
    NavigationDestination(
      selectedIcon: AppIcons.offersSolid(size: 24, color: Color(0xFF19276F)),
      icon: AppIcons.offersOutline(size: 24, color: Color(0xFF19276F)),
      label: 'הטבות',
    ),
    NavigationDestination(
      selectedIcon: AppIcons.searchSolid(size: 24, color: Color(0xFF19276F)),
      icon: AppIcons.searchOutline(size: 24, color: Color(0xFF19276F)),
      label: 'חיפוש',
    ),
    NavigationDestination(
      selectedIcon: AppIcons.profileSolid(size: 24, color: Color(0xFF19276F)),
      icon: AppIcons.profileOutline(size: 24, color: Color(0xFF19276F)),
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
