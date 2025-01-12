import 'package:flutter/material.dart';
import '../../config.dart';
import 'deal_query_item.dart';
import 'deal_list.dart'; // Import the new DealCard file
import '../../services/deal_service.dart';

class DealQuery extends StatefulWidget {
  final String title;
  final String query;

  const DealQuery({required this.title, required this.query, Key? key}) : super(key: key);
  
  @override
  _DealQueryState createState() => _DealQueryState();
}

class _DealQueryState extends State<DealQuery> with AutomaticKeepAliveClientMixin  {
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
      final fetchedDeals = await dealService.fetchDealsByQuery(widget.query);
      setState(() {
        deals = fetchedDeals;
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
        return isLoading
        ? const Center(child: CircularProgressIndicator())
        : deals.isEmpty
            ? const Center(child: Text('אין הטבות'))
            : Padding(
                padding: const EdgeInsets.all(AppTheme.itemPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: AppTheme.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DealListScreen(query: widget.query),
                              ),
                            );
                          },
                          child: Text('עוד', style: AppTheme.item),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.itemPadding),
                    // Horizontal Deals List
                    SizedBox(
                      height: 212,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: deals.length,
                        itemBuilder: (context, index) {
                          final deal = deals[index];
                          return DealQueryItem(
                            imageUrl: deal['imagePath'] ?? 'default',
                            name: deal['name'] ?? 'New Deal',
                            description: deal['description'] ?? '',
                            dealId: deal['_id'],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
  
  @override
  bool get wantKeepAlive => true;
}
