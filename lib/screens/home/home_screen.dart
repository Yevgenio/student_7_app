import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/layout/app_drawer.dart';
import 'package:student_7_app/layout/app_nav.dart';
import 'package:student_7_app/screens/chat/chat_screen.dart';
import 'package:student_7_app/screens/home/home_mininav.dart';
import 'package:student_7_app/screens/home/home_search.dart';
import 'package:student_7_app/widgets/login_widget.dart';
import 'home_memo.dart';
import '../../layout/app_bar.dart';

import '../../services/chat_service.dart';
import '../../services/deal_service.dart';
import '../../services/auth_service.dart';

import '../deal/deal_query.dart';
import '../chat/chat_query.dart';

import '../user/user_login_screen.dart';
import '../user/user_signup_screen.dart';
import '../user/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService chatService = ChatService();
  final DealService dealService = DealService();

  List<dynamic> chats = [];
  List<dynamic> deals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final chatData = await chatService.fetchChats();
      final dealsData = await dealService.fetchDeals();
      setState(() {
        chats = chatData;
        deals = dealsData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'סטודנט 7',
        actions: [
          LoginWidget(),
        ],
      ),
      // drawer: AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Login/Signup or Welcome Section
                HomeSearch(),

                const SizedBox(height: 16),

                HomeMiniNav(),

                const SizedBox(height: 16),

                // Chat Section
                // const SizedBox(height: 8),
                ChatQuery(title: 'קבוצות חדשות', query: 'sort=recent&limit=10'),

                const SizedBox(height: 16),

                // Deal Section
                // const SizedBox(height: 8),
                DealQuery(title: 'הטבות חדשות', query: 'sort=recent&limit=10'),
              ],
            )),
      // bottomNavigationBar: AppNavbar(context: context, selectedIndex: 0),
    );
  }
}


