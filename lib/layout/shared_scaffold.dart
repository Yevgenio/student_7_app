import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/layout/app_icons.dart';
import 'package:student_7_app/layout/app_nav.dart';
import 'package:student_7_app/models/user_model.dart';
import 'package:student_7_app/providers/auth_provider.dart';
import 'package:student_7_app/routes/routes.dart';
import 'package:student_7_app/screens/chat/chat_catalog.dart';
import 'package:student_7_app/screens/chat/chat_details_screen.dart';
import 'package:student_7_app/screens/deal/deal_catalog.dart';
import 'package:student_7_app/screens/deal/deal_details_screen.dart';
import 'package:student_7_app/screens/home/home_screen.dart';
import 'package:student_7_app/screens/search/search_screen.dart';
import 'package:student_7_app/screens/user/auth_selection_screen.dart';
import 'package:student_7_app/screens/user/user_profile_screen.dart';
import 'package:student_7_app/services/auth_service.dart';
import 'package:provider/provider.dart';
class SharedScaffold extends StatefulWidget {
  const SharedScaffold({Key? key}) : super(key: key);

  @override
  _SharedScaffoldState createState() => _SharedScaffoldState();
}

class _SharedScaffoldState extends State<SharedScaffold> {
  int _selectedIndex = 0;
  final AuthService authService = AuthService();
  User? user;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUser();
  //  await _fetchUserState();
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    //await Future.delayed(const Duration(seconds: 3));
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
    final authProvider = Provider.of<AuthProvider>(context);
    user = authProvider.user;

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/chatDetails') {
            final chatId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ChatDetailsScreen(chatId: chatId),
            );
          }
          if (settings.name == '/dealDetails') {
            final dealId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => DealDetailsScreen(dealId: dealId),
            );
          }
          if (settings.name == '/login') {
            return MaterialPageRoute(
              builder: (context) => AuthSelectionScreen(),
            );
          }
          Widget route;
          switch (index) {
            case 0:
              route = const HomeScreen();
              break;
            case 1:
              route = const ChatCatalog();
              break;
            case 2:
              route = const DealCatalog();
              break;
            case 3:
              route = const SearchScreen();
              break;
            case 4:
              route = const ProfileScreen();
              // _fetchUserState();
              // route = user == null
              //     ? const AuthSelectionScreen() // Redirect to AuthSelectionScreen if not logged in
              //     : const ProfileScreen();
              break;
            default:
              route = const HomeScreen();
          }

          return MaterialPageRoute(
            builder: (context) => route,
            settings: settings,
          );
        },
      ),
    );
  }


@override
Widget build(BuildContext context) {
  // _fetchUserState();
  final authProvider = Provider.of<AuthProvider>(context);
  user = authProvider.user;

  // Generate destinations dynamically
  List<NavigationDestination> destinations = <NavigationDestination>[
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
      // Use username if available, otherwise default to 'פרופיל'
      label: user != null ? 'פרופיל' : 'התחבר',
    ),
  ];
  
  return WillPopScope(
      onWillPop: () async {
      final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
      if (isFirstRouteInCurrentTab) {
        if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
        return false; // Prevent default back navigation
        }
        return true; // Allow default back navigation for the home tab
      }
      return false; // Prevent default back navigation
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
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              _onTabTapped(index);
            },
            destinations: destinations,
          ),
        ),
      ),
    );
  }
}
