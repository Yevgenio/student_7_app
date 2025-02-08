import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_7_app/services/search_service.dart';
import 'dart:convert';
import '../../config.dart';
import '../../layout/app_bar.dart';
import 'search_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = SearchService();
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  List<bool> _selections = [false, false]; // [Chats, Deals]
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _fetchSearchResults(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
    });

    List<String> selectedTypes = [];
    if (_selections[0]) selectedTypes.add('chats');
    if (_selections[1]) selectedTypes.add('deals');

    try {
      if (selectedTypes.isEmpty) {
        final results = await _searchService.fetchGlobalSearchResults(query);
        setState(() {
          _searchResults = [
            ...results['chats'] ?? [],
            ...results['deals'] ?? []
          ];
        });
      } else {
        List<dynamic> combinedResults = [];
        for (String type in selectedTypes) {
          final results =
              await _searchService.fetchSearchResultsByType(query, type);
          combinedResults.addAll(results);
        }
        setState(() {
          _searchResults = combinedResults;
        });
      }
    } catch (e) {
      print('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'חיפוש',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'הקלד לחיפוש...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon:
                        Icon(Icons.search, color: AppTheme.secondaryColor),
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppTheme.secondaryColor),
                    ),
                  ),
                  style: TextStyle(color: AppTheme.secondaryColor),
                ),
                // const SizedBox(height: 16),
                Wrap(
                  children: [
                    // const Text(
                    //   "סוג תוצאות:",
                    //   style: TextStyle(color: AppTheme.primaryColor),
                    // ),
                    ToggleButtons(
                      isSelected: _selections,
                      onPressed: (index) {
                        setState(() {
                          _selections[index] = !_selections[index];
                          _onSearchChanged(); // Re-fetch results on selection change
                        });
                      },
                      borderColor: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                      selectedBorderColor:
                          Colors.transparent, // Border color when selected
                      splashColor: Colors.transparent,
                      disabledColor: AppTheme.cardColor, // Disabled state color
                      selectedColor:
                          AppTheme.secondaryColor, // Text color when selected
                      fillColor:
                          Colors.transparent, // Background color when selected
                      hoverColor: Colors.transparent,
                      color:
                          AppTheme.primaryColor, // Text color when not selected
                      // constraints: const BoxConstraints(
                      //   minHeight: 40, // Minimum height for buttons
                      //   minWidth: 120, // Minimum width for buttons
                      // ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8), // Margin between buttons
                            child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              boxShadow: [AppTheme.primaryShadow],
                              // border: Border.all(color: Colors.grey[400] ?? Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('קבוצות ווצאפ'),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8), // Margin between buttons
                                child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.cardColor, // Background color set to white
                                  boxShadow: [AppTheme.primaryShadow],
                                  // border: Border.all(color: Colors.grey[400] ?? Colors.grey),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('הטבות ומבצעים'),
                                ),
                         
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(child: Text('אין תוצאות'))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return SearchItem(
                        imageUrl: result['imagePath'] ?? 'default',
                        name: result['name'] ?? 'New Chat',
                        description: result['description'] ?? '',
                        itemType:
                            result['barcodePath'] != null ? 'deal' : 'chat',
                        itemId: result['_id'],
                      );
                    },
                  ),
          ),
        ],
      ),
      // bottomNavigationBar: AppNavbar(context: context, selectedIndex: 3),
    );
  }
}
