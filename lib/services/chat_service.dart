import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ChatService {
  final String baseUrl = '${Config.apiBaseUrl}/api/chats';
  final String uploadUrl = '${Config.apiBaseUrl}/api/uploads';

  Future<List<dynamic>> fetchChats() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      // Update image paths to include the full API URL
      for (var item in data) {
        if (item['imagePath'] != null) {
          item['imagePath'] = '$uploadUrl/${item['imagePath']}';
        }
      }
      return data;
    } else {
      throw Exception('Failed to load chat');
    }
  }

  Future<Map<String, dynamic>> fetchChatById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/id/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Update image paths to include the full API URL
      if (data['imagePath'] != null) {
        data['imagePath'] = '$uploadUrl/${data['imagePath']}';
      }
      return data;
    } else {
      throw Exception('Failed to load this chat');
    }
  }
}

