import 'package:flutter/material.dart';
import 'chat/chat_groups_screen.dart';
import 'deals_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  // Keys for nested navigators
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // final List<String> _titles = ['בית', 'קבוצות', 'הטבות', 'חיפוש', 'פרופיל'];

  void _onTabTapped(int index) {
    // Reset the current tab by popping all routes to the first route
    _navigatorKeys[_selectedIndex].currentState?.popUntil((route) => route.isFirst);
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (index) {
            case 0:
              page = HomeScreen();
              break;
            case 1:
              page = ChatGroupsScreen();
              break;
            case 2:
              page = DealsScreen();
              break;
            case 3:
              page = SearchScreen();
              break;
            case 4:
              page = ProfileScreen();
              break;
            default:
              page = HomeScreen();
          }
          return MaterialPageRoute(
            builder: (context) => page,
            settings: settings,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(_titles[_selectedIndex]),
        // ),
        body: Stack(
          children: List.generate(
            5,
            (index) => _buildOffstageNavigator(index),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'בית',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'קבוצות',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              label: 'הטבות',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'חיפוש',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'פרופיל',
            ),
          ],
        ),
      ),
    );
  }
}
