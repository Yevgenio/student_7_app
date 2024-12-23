import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_7_app/services/search_service.dart';
import 'dart:convert';
import '../../config.dart';
import '../../layout/app_bar.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onBackToHome;

  const SearchScreen({required this.onBackToHome, Key? key}) : super(key: key);

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
          _searchResults = [...results['chats'] ?? [], ...results['deals'] ?? []];
        });
      } else {
        List<dynamic> combinedResults = [];
        for (String type in selectedTypes) {
          final results = await _searchService.fetchSearchResultsByType(query, type);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToHome,
        ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ToggleButtons(
                  isSelected: _selections,
                  onPressed: (index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                      _onSearchChanged(); // Re-fetch results on selection change
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  color: Colors.black,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Chats'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Deals'),
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
                      return Card(
                        margin: const EdgeInsets.all(16),
                        child: ListTile(
                          leading: result['imagePath'] != null
                              ? Image.network(result['imagePath'], width: 50, height: 50)
                              : const Icon(Icons.image_not_supported),
                          title: Text(
                            result['name'] ?? 'No Name',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,),
                          subtitle: Text(
                            result['description'] ?? 'No Description',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
