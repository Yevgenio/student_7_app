import 'package:flutter/material.dart';
import '../../services/deal_service.dart';
import '../../config.dart';

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
        title: Text('פרטי ההטבה', style: AppTheme.h3),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dealDetails != null
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(AppTheme.itemPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image and Title Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          if (dealDetails!['imagePath'] != null)
                            GestureDetector(
                              onTap: () => _showImageDialog(dealDetails!['imagePath']),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [AppTheme.secondaryShadow],
                                  image: DecorationImage(
                                    image: NetworkImage(dealDetails!['imagePath']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          else
                            Icon(Icons.image, size: 80, color: AppTheme.secondaryColor),
                          SizedBox(width: AppTheme.itemPadding),
                          // Title
                          Expanded(
                            child: Text(
                              dealDetails!['name'] ?? 'הטבה',
                              style: AppTheme.h2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppTheme.itemPadding),
                      // Category Chip
                      if (dealDetails!['category'] != null && dealDetails!['category']!.trim().isNotEmpty)
                        Chip(
                          label: Text(
                            dealDetails!['category'],
                            style: AppTheme.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                        ),
                      SizedBox(height: AppTheme.itemPadding),
                      // Description
                      Text(
                        dealDetails!['description'] ?? '',
                        style: AppTheme.p,
                      ),
                      SizedBox(height: AppTheme.itemPadding),
                      // Ends At
                      if (dealDetails!['endsAt'] != null)
                        Text(
                          'זמין עד: ${dealDetails!['endsAt']}',
                          style: AppTheme.item,
                        ),
                      SizedBox(height: AppTheme.itemPadding),
                      // Barcode Button
                      if (dealDetails!['barcodePath'] != null)
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _showBarcodeDialog(dealDetails!['barcodePath']),
                            icon: Icon(Icons.qr_code),
                            label: Text('הצג ברקוד'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : Center(child: Text('ההטבה לא נמצאה', style: AppTheme.p)),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(imagePath, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  void _showBarcodeDialog(String barcodePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(barcodePath, fit: BoxFit.contain),
          ),
        );
      },
    );
  }
}
