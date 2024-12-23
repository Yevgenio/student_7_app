import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/chat/chat_details_screen.dart';
import 'app_icons.dart';
import '../screens/chat/chat_screen.dart';

import '../screens/deal/deal_screen.dart';
import '../screens/deal/deal_details_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/user/user_profile_screen.dart';
import '../screens/search/search_screen.dart';

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
  
  late final List<Widget> _pages = [
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        if (settings.name == '/dealDetails') {
          // setIndex(2);
          final dealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DealDetailsScreen(dealId: dealId),
          );
        }
        if (settings.name == '/chatDetails') {
          // setIndex(2);
          final chatId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ChatDetailsScreen(chatId: chatId),
          );
        }
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      },
    ),
    ChatScreen(onBackToHome: () => {setIndex(0)}),
    DealScreen(onBackToHome: () => {setIndex(0)}),
    SearchScreen(onBackToHome: () => {setIndex(0)}),
    Placeholder(), // ProfileScreen to be replaced dynamically
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
                  ? ProfileScreen(token: token!, onBackToHome: () => {setIndex(0)})
                  : const Center(
                      child: Text('Please log in to view your profile.'));
            }
            return page;
          }).toList(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: setIndex,
          destinations: _destinations,
        ),
      ),
    );
  }
}
