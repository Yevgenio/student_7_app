import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class SearchService {
  final String baseUrl = '${Config.apiBaseUrl}/api/search';
  final String uploadUrl = '${Config.apiBaseUrl}/api/uploads';

  // Fetch results for global search
  Future<Map<String, List<dynamic>>> fetchGlobalSearchResults(String query, {String? type}) async {
    String url = '$baseUrl?query=$query';
    if (type != null) {
      url += '&type=$type';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final deals = _processImagePaths(data['deals'] ?? []);
      final chats = _processImagePaths(data['chats'] ?? []);

      return {
        'deals': deals,
        'chats': chats,
      };
    } else {
      throw Exception('Failed to fetch search results');
    }
  }

  // Fetch search results filtered by type
  Future<List<dynamic>> fetchSearchResultsByType(String query, String type) async {
    final results = await fetchGlobalSearchResults(query, type: type);
    return results[type] ?? [];
  }

  // Process image paths for results
  List<dynamic> _processImagePaths(List<dynamic> items) {
    for (var item in items) {
      if (item['imagePath'] != null) {
        item['imagePath'] = '$uploadUrl/${item['imagePath']}';
      } else {
        item['imagePath'] = '$uploadUrl/default';
      }
    }
    return items;
  }
}
