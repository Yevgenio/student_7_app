import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = 'http://51.84.9.120:5000/api'; // Replace with your actual IP

  Future<List<dynamic>> fetchChats() async {
    final response = await http.get(Uri.parse('$baseUrl/chats'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decode JSON data into a list
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<Map<String, dynamic>> fetchChatById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/chats/id/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decode JSON data for a specific chat
    } else {
      throw Exception('Failed to load this chat');
    }
  }
}
