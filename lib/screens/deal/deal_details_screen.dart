import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/widgets/cached_image.dart';
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
      appBar: CustomAppBar(title: 'פרטי ההטבה',),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dealDetails != null
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(AppTheme.itemPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          if (dealDetails!['imagePath'] != null)
                            GestureDetector(
                              onTap: () => _showImageDialog(dealDetails!['imagePath']),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedImage(
                                  imagePath: dealDetails!['imagePath'],
                                  height: 200, // Set a maximum height
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Icon(Icons.image, size: 80, color: AppTheme.secondaryColor),
                          SizedBox(width: AppTheme.itemPadding),
                      // Image and Title Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // Image

                          // Title
                          Expanded(
                            child: Text(
                              dealDetails!['name'] ?? 'הטבה',
                              style: AppTheme.h2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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
                      _buildDescription(dealDetails!['description'] ?? ''),
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
            child: CachedImage(imagePath: imagePath, fit: BoxFit.cover),
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
            child: CachedImage(imagePath: barcodePath, fit: BoxFit.contain),
          ),
        );
      },
    );
  }

  Widget _buildDescription(String description) {
    // Regular expression to match URLs starting with http, https, or www
    final regex = RegExp(
        r'(https?:\/\/[^\s]+|www\.[^\s]+)',
        caseSensitive: false);

    final spans = <TextSpan>[];

    description.splitMapJoin(
      regex,
      onMatch: (match) {
        final url = match.group(0)!; // Extract the matched URL
        final displayText = url.startsWith('www') ? 'https://$url' : url; // Add scheme to "www" if missing
        spans.add(TextSpan(
          text: url,
          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(displayText);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                print('Could not launch $displayText');
              }
            },
        ));
        return '';
      },
      onNonMatch: (text) {
        spans.add(TextSpan(text: text, style: AppTheme.p));
        return '';
      },
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
