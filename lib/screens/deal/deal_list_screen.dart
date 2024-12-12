import 'package:flutter/material.dart';
import 'package:student_7_app/config.dart';
import '../../services/deal_service.dart';
import 'deal_details_screen.dart';

class DealsScreen extends StatefulWidget {
  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
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
        String category = deal['category'] ?? 'Uncategorized';
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
        title: Text('עמוד ההטבות'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dealsByCategory.keys.length,
              itemBuilder: (context, index) {
                String category = dealsByCategory.keys.elementAt(index);
                List<dynamic> deals = dealsByCategory[category]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Title
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Horizontal Scroll of Deals
                      SizedBox(
                        height: 200, // Fixed height for the deal cards
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: deals.length,
                          itemBuilder: (context, index) {
                            final deal = deals[index];
                            return DealCard(
                              imageUrl: deal['imagePath'] ?? '',
                              name: deal['name'] ?? '',
                              description: deal['description'] ?? '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DealDetailsScreen(dealId: deal['_id']),
                                  ),
                                );
                              },
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

class DealCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final VoidCallback onTap;

  const DealCard({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Fixed width for the deal cards
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.cardColor,
          boxShadow: const [AppTheme.primaryShadow]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deal Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            // Deal Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                style: AppTheme.label,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            // Deal Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                description,
                style: AppTheme.p,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Text(
            //     name,
            //     style: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            // const SizedBox(height: 5),
            // // Deal Description
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Text(
            //     description,
            //     style: const TextStyle(fontSize: 14, color: Colors.grey),
            //     maxLines: 2,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),