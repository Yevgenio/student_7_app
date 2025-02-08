import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:student_7_app/config.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/widgets/cached_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/memo_service.dart'; // Replace with your actual path

class MemoDetailsScreen extends StatefulWidget {
  final String memoId;

  MemoDetailsScreen({required this.memoId});

  @override
  _MemoDetailsScreenState createState() => _MemoDetailsScreenState();
}

class _MemoDetailsScreenState extends State<MemoDetailsScreen> {
  final MemoService memoService = MemoService();
  Map<String, dynamic>? memoDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    try {
      final data = await memoService.fetchMemoById(widget.memoId);
      setState(() {
        memoDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching group details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: memoDetails?['name'] ?? 'פרטי הכרזה',
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : memoDetails != null
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Constrain the image size
                          if (memoDetails!['imagePath'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedImage(
                                imagePath: memoDetails!['imagePath'],
                                fit: BoxFit.cover,
                                height: 200, // Set a maximum height
                                width: double.infinity,
                              ),
                            ),
                          SizedBox(height: 16), // Add spacing
                          Text(
                            memoDetails!['name'],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          if (memoDetails!['category'] != null && memoDetails!['category']!.trim().isNotEmpty)
                            Chip(
                              label: Text(
                                memoDetails!['category'],
                                style: AppTheme.label,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                            ),
                          SizedBox(height: 8),
                          _buildDescription(memoDetails!['description'] ?? ''),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                openWhatsApp(memoDetails!['link']);
                              },
                              child: Text('הצטרף לקבוצה'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: Text('הכרזה לא נמצאה')),
    );
  }

  void openWhatsApp(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
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

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }
}
