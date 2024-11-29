import 'package:flutter/material.dart';
import 'services/deal_service.dart';
import 'deal_details_screen.dart';

class DealsScreen extends StatefulWidget {
  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
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
      final data = await dealService.fetchDeals();
      setState(() {
        deals = data;
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
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Card(
                  child: ListTile(
                    leading: deal['imageUrl'] != null
                        ? Image.network(deal['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.local_offer),
                    title: Text(deal['name']),
                    subtitle: Text(deal['description'] ?? 'No description available'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DealDetailsScreen(dealId: deal['_id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
