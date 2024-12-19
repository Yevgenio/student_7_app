import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class DealService {
  final String baseUrl = '${Config.apiBaseUrl}/api/deals';
  final String uploadUrl = '${Config.apiBaseUrl}/api/uploads';

  Future<List<dynamic>> fetchDeals() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Update image paths to include the full API URL
      for (var item in data) {
        if (item['imagePath'] != null) {
          item['imagePath'] = '$uploadUrl/${item['imagePath']}';
        } else {
          item['imagePath'] = '$uploadUrl/default';
        }
        if (item['barcodePath'] != null) {
          item['barcodePath'] = '$uploadUrl/${item['barcodePath']}';
        } else {
          item['barcodePath'] = '$uploadUrl/default';
        }
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
      if (data['imagePath'] != null) {
        data['imagePath'] = '$uploadUrl/${data['imagePath']}';
      }
      if (data['barcodePath'] != null) {
        data['barcodePath'] = '$uploadUrl/${data['barcodePath']}';
      }
      return data;
    } else {
      throw Exception('Failed to load this deal');
    }
  }

  Future<List<dynamic>> fetchDealsByQuery(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?$query'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey('data')) {
        final data = decodedResponse['data'];
        // Update image paths to include the full API URL
        for (var item in data) {
          if (item['imagePath'] != null) {
            item['imagePath'] = '$uploadUrl/${item['imagePath']}';
          } else {
            item['imagePath'] = '$uploadUrl/default';
          }

          if (item['barcodePath'] != null) {
            item['barcodePath'] = '$uploadUrl/${item['barcodePath']}';
          } else {
            item['barcodePath'] = '$uploadUrl/default';
          }
        }
        print(data);
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
}
