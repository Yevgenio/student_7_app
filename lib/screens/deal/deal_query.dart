import 'package:flutter/material.dart';
import '../../services/deal_service.dart';
import 'deal_item.dart'; // Import the DealCard widget

class DealQuery extends StatefulWidget {
  final String query; // API query string

  const DealQuery({required this.query, Key? key}) : super(key: key);

  @override
  _DealQueryState createState() => _DealQueryState();
}

class _DealQueryState extends State<DealQuery> {
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
      print('Error fetching deals: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 10 Newest Deals'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deals.isEmpty
              ? const Center(child: Text('No deals available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two deals per row
                      crossAxisSpacing: 10.0, // Space between columns
                      mainAxisSpacing: 10.0, // Space between rows
                      childAspectRatio: 0.7, // Aspect ratio for cards
                    ),
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final deal = deals[index];
                      return DealCard(
                        imageUrl: deal['imagePath'] ?? 'default',
                        name: deal['name'] ?? 'הטבה חדשה',
                        description: deal['description'] ?? 'לחברי סטודנט 7',
                        dealId: deal['_id'],
                      );
                    },
                  ),
                ),
    );
  }
}
