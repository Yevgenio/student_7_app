import 'package:flutter/material.dart';
import 'package:student_7_app/widgets/card_widget.dart';
import '../../layout/app_bar.dart';

import '../../services/deal_service.dart';

class DealListScreen extends StatefulWidget {
  final String query;

  const DealListScreen({required this.query, Key? key}) : super(key: key);

  @override
  _DealListScreenState createState() => _DealListScreenState();
}

class _DealListScreenState extends State<DealListScreen> {
  final DealService dealService = DealService();
  List<dynamic> deals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeals();
  }

  Future<void> fetchDeals() async {
    try {
      final response = await dealService.fetchDealsByQuery(widget.query);
      setState(() {
        deals = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'כל ההטבות'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return CardWidget(
                  imageUrl: deal['imagePath'] ?? 'default',
                  name: deal['name'] ?? 'New Deal',
                  description: deal['description'] ?? 'Student 7',
                  itemId: deal['_id'],
                  navigatorRoute: '/dealDetails',
                );
              },
            ),
    );
  }
}
