import 'package:flutter/material.dart';
import '../../services/deal_service.dart';

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
                        if (dealDetails!['imagePath'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              dealDetails!['imagePath'],
                              fit: BoxFit.cover,
                              height: 200, // Set a maximum height
                              width: double.infinity,
                            ),
                          ),
                      SizedBox(height: 16),
                      Text(
                        dealDetails!['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(dealDetails!['description'] ?? ''),
                      SizedBox(height: 8),
                      Text(
                        'Category: ${dealDetails!['category'] ?? 'כללי'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      if(dealDetails!['endsAt'] != null) 
                        Text(
                          'Available until: ${dealDetails!['endsAt']}',
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
