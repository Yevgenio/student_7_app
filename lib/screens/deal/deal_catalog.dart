import 'package:flutter/material.dart';
import 'package:student_7_app/layout/app_bar.dart';
import 'package:student_7_app/layout/app_nav.dart';

import '../../services/deal_service.dart';
import 'deal_query.dart'; // Import the new DealCard file

class DealCatalog extends StatefulWidget {

  const DealCatalog({super.key});

  @override
  _DealCatalogState createState() => _DealCatalogState();
}

class _DealCatalogState extends State<DealCatalog> {
  final DealService dealService = DealService();
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await dealService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'עמוד ההטבות',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final title = categories[index] == "" ? "כללי" : categories[index];
                final category = categories[index];
                return DealQuery(title: title, query: "category=$category");
              },
            ),
    // bottomNavigationBar: AppNavbar(context: context, selectedIndex: 2),
    );
  }
}

                //String category = dealsByCategory.keys.elementAt(index);
                // List<dynamic> deals = dealsByCategory[category]!;

                // return Padding(
                //   padding: const EdgeInsets.only(
                //       bottom: AppTheme.sectionPadding, 
                //       right: AppTheme.itemPadding
                //       ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       // Category Title
                //       Text(
                //         category,
                //         style: AppTheme.label,
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 1,
                //       ),
                //       const SizedBox(height: AppTheme.itemPadding),
                //       // Horizontal Scroll of Deals
                //       SizedBox(
                //         height: 212,
                //         child: ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           itemCount: deals.length,
                //           itemBuilder: (context, index) {
                //             final deal = deals[index];
                //             return DealCard(
                //               imageUrl: deal['imagePath'] ?? 'default',
                //               name: deal['name'] ?? 'הטבה חדשה',
                //               description: deal['description'] ?? 'סטודנט 7',
                //               dealId: deal['_id'],
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // );