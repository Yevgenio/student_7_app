import 'package:flutter/material.dart';
import '../../config.dart';

import '../../services/deal_service.dart';
import 'deal_item.dart'; // Import the new DealCard file
import 'deal_details_screen.dart';

class DealList extends StatefulWidget {
  final VoidCallback onBackToHome;

  const DealList({required this.onBackToHome, Key? key}) : super(key: key);

  @override
  _DealListState createState() => _DealListState();
}

class _DealListState extends State<DealList> {
  final DealService dealService = DealService();
  Map<String, List<dynamic>> dealsByCategory = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeals();
  }

  Future<void> fetchDeals() async {
    try {
      final data = await dealService.fetchDeals();

      // Group deals by category
      Map<String, List<dynamic>> groupedData = {};
      for (var deal in data) {
        // Check if category is null or empty
        String category = (deal['category'] == null || deal['category'].trim().isEmpty)
            ? 'כללי'
            : deal['category'];

        if (!groupedData.containsKey(category)) {
          groupedData[category] = [];
        }
        groupedData[category]!.add(deal);
      }

      setState(() {
        dealsByCategory = groupedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching deals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('עמוד ההטבות', style: AppTheme.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToHome, 
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dealsByCategory.keys.length,
              itemBuilder: (context, index) {
                String category = dealsByCategory.keys.elementAt(index);
                List<dynamic> deals = dealsByCategory[category]!;

                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppTheme.sectionPadding, 
                      right: AppTheme.itemPadding
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Title
                      Text(
                        category,
                        style: AppTheme.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: AppTheme.itemPadding),
                      // Horizontal Scroll of Deals
                      SizedBox(
                        height: 212,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: deals.length,
                          itemBuilder: (context, index) {
                            final deal = deals[index];
                            return DealCard(
                              imageUrl: deal['imagePath'] ?? 'default',
                              name: deal['name'] ?? 'הטבה חדשה',
                              description: deal['description'] ?? 'סטודנט 7',
                              dealId: deal['_id'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
