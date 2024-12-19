import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_icons.dart';
import 'chat/chat_screen.dart';
import 'deal/deal_screen.dart'; 
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
  String? token; // Store the token here for ProfileScreen

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  // Pages corresponding to the navigation destinations
late final List<Widget> _pages = [
    HomeScreen(),
    ChatScreen(onBackToHome: () => setIndex(0)), 
    DealScreen(onBackToHome: () => setIndex(0)),
    SearchScreen(),
    Placeholder(), // Ensure token is passed dynamically
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
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages.map((page) {
            if (page is Placeholder && _selectedIndex == 4) {
              // Handle ProfileScreen navigation manually
              return token != null
                  ? ProfileScreen(token: token!)
                  : const Center(child: Text('Please log in to view your profile.'));
            }
            return page;
          }).toList(),
        ),
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
