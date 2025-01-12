import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'image_service.dart';

class SearchService {
  final String baseUrl = '${ServerAPI.baseUrl}/api/search';

  // Fetch results for global search
  Future<Map<String, List<dynamic>>> fetchGlobalSearchResults(String query, {String? type}) async {
    String url = '$baseUrl?query=$query';
    if (type != null) {
      url += '&type=$type';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final deals = await _processImagePaths(data['deals'] ?? []);
      final chats = await _processImagePaths(data['chats'] ?? []);

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
  Future<List> _processImagePaths(List<dynamic> items) async {
    for (var item in items) {
      item['imagePath'] = await ImageService.getProcessedImageUrl(item['imagePath']);
      item['barcodePath'] = await ImageService.getProcessedImageUrl(item['barcodePath']);
    }
    return items;
  }
}
