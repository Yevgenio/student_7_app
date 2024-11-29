import 'dart:convert';
import 'package:http/http.dart' as http;

class DealService {
  final String baseUrl = 'http://51.84.9.120:5000/api'; // Replace with your actual IP

  Future<List<dynamic>> fetchDeals() async {
    final response = await http.get(Uri.parse('$baseUrl/deals'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decode JSON data into a list
    } else {
      throw Exception('Failed to load deals');
    }
  }

  Future<Map<String, dynamic>> fetchDealById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/deals/id/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decode JSON data for a specific deal
    } else {
      throw Exception('Failed to load this deal');
    }
  }
}
