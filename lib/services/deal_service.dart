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
        }
        if (item['barcodePath'] != null) {
          item['barcodePath'] = '$uploadUrl/${item['barcodePath']}';
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
}
