import 'dart:convert';
import 'package:http/http.dart' as http;
import 'image_service.dart';
import '../config.dart';

class DealService {
  final String baseUrl = '${ServerAPI.baseUrl}/api/deals';

  Future<List<dynamic>> fetchDeals() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Update image paths to include the full API URL
      for (var item in data) {
        item['imagePath'] =
            await ImageService.getProcessedImageUrl(item['imagePath']);

        item['barcodePath'] =
            await ImageService.getProcessedImageUrl(item['barcodePath']);
      }
      return data;
    } else {
      throw Exception('Failed to load deals');
    }
  }

  Future<Map<String, dynamic>> fetchDealById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/id/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Update image paths to include the full API URL
      data['imagePath'] =
          await ImageService.getProcessedImageUrl(data['imagePath']);
      data['barcodePath'] =
          await ImageService.getProcessedImageUrl(data['barcodePath']);
      return data;
    } else {
      throw Exception('Failed to load this deal');
    }
  }

  Future<List<dynamic>> fetchDealsByQuery(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey('data')) {
        final data = decodedResponse['data'];
        // Update image paths to include the full API URL
        for (var item in data) {
          item['imagePath'] =
              await ImageService.getProcessedImageUrl(item['imagePath']);
          item['barcodePath'] =
              await ImageService.getProcessedImageUrl(item['barcodePath']);
        }
        return data;
      } else {
        throw Exception('Unexpected response format: "data" field missing');
      }
    } else {
      // Throw an exception if the HTTP status code is not 200
      throw Exception(
          'Failed to fetch deals. Status Code: ${response.statusCode}');
    }
  }

  // GET distinct categories
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  // GET deals by categories
  Future<List<dynamic>> fetchDealsByCategoryLimit(String category) async {
    return fetchDealsByQuery('category=$category&limit=10');
  }

  // GET deals by categories
  Future<List<dynamic>> fetchDealsByCategoryAll(String category) async {
    return fetchDealsByQuery('category=$category');
  }
}
