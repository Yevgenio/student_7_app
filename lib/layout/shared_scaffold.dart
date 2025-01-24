import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:student_7_app/layout/app_icons.dart';
import 'package:student_7_app/layout/app_nav.dart';
import 'package:student_7_app/routes/routes.dart';
import 'package:student_7_app/screens/chat/chat_catalog.dart';
import 'package:student_7_app/screens/chat/chat_details_screen.dart';
import 'package:student_7_app/screens/deal/deal_catalog.dart';
import 'package:student_7_app/screens/deal/deal_details_screen.dart';
import 'package:student_7_app/screens/home/home_screen.dart';
import 'package:student_7_app/screens/search/search_screen.dart';
import 'package:student_7_app/screens/user/user_profile_screen.dart';

class SharedScaffold extends StatefulWidget {
  const SharedScaffold({Key? key}) : super(key: key);

  @override
  _SharedScaffoldState createState() => _SharedScaffoldState();
}

class _SharedScaffoldState extends State<SharedScaffold> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

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
    _navigatorKeys[_selectedIndex]
        .currentState
        ?.popUntil((route) => route.isFirst);
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
          if (settings.name == '/chatDetails') {
            final chatId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) =>
                  ChatDetailsScreen(chatId: chatId),
            );
          }
          if (settings.name == '/dealDetails') {
            final dealId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) =>
                  DealDetailsScreen(dealId: dealId),
            );
          }
          Widget route;
          switch (index) {
            case 0:
              route = HomeScreen();
              break;
            case 1:
              route = ChatCatalog();
              break;
            case 2:
              route = DealCatalog();
              break;
            case 3:
              route = SearchScreen();
              break;
            case 4:
              route = ProfileScreen();
              break;
            default:
              route = HomeScreen();
          }

          return MaterialPageRoute(
            builder: (context) => route,
            settings: settings,
          );
        },
      ),
    );
  }

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
    return WillPopScope(
      onWillPop: () async {
        // Handle back button navigation
        if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
        return false; // Prevent default back navigation
        } else {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          return true; // Allow default back navigation for the home tab
        }
        return false; // Prevent default back navigation
        }
      },
      child: Directionality(
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
          bottomNavigationBar: 
          
          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
               _onTabTapped(index);
            },
            destinations: _destinations,
          ),
        
        ),
      ),
    );
  }
}


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/deals':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => DealCatalog(),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}