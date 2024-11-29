import 'package:flutter/material.dart';
import 'services/deal_service.dart';

class DealDetailsScreen extends StatefulWidget {
  final String dealId;

  DealDetailsScreen({required this.dealId});

  @override
  _DealDetailsScreenState createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
  final DealService dealService = DealService();
  Map<String, dynamic>? dealDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDealDetails();
  }

  Future<void> fetchDealDetails() async {
    try {
      final data = await dealService.fetchDealById(widget.dealId);
      setState(() {
        dealDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching deal details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dealDetails != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dealDetails!['imageUrl'] != null
                          ? Image.network(dealDetails!['imageUrl'], fit: BoxFit.cover)
                          : Icon(Icons.local_offer, size: 100),
                      SizedBox(height: 16),
                      Text(
                        dealDetails!['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(dealDetails!['description'] ?? 'No description available'),
                      SizedBox(height: 16),
                      Text(
                        'Price: ${dealDetails!['price'] ?? 'Not available'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Category: ${dealDetails!['category'] ?? 'No category'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Available until: ${dealDetails!['endsAt'] ?? 'No end date'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Add any functionality for generating or viewing QR code here
                          print('Show QR Code functionality');
                        },
                        child: Text('Show QR Code'),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('Deal not found')),
    );
  }
}
