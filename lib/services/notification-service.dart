import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_frontend/utils/constants.dart';

class NotifService {
  static const String baseUrl = BASE_URL;

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> isRead(int notificationId) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/users/notificationRead'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: json.encode({'notification_id': notificationId}),
    );

    if (response.statusCode == 200) {
      // Mengembalikan response['data'] yang berisi informasi notifikasi yang telah diubah statusnya
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Update failed');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> get() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/notification'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // Pastikan 'data' ada di dalam responseBody
      if (responseBody['data'] == null) {
        throw Exception('Data is null');
      }

      Map<String, List<Map<String, dynamic>>> result = {
        'notifications': List<Map<String, dynamic>>.from(
            responseBody['data']['notifications'] ?? []),
        'notificationReads': List<Map<String, dynamic>>.from(
            responseBody['data']['notificationReads'] ?? []),
        'notificationCategories': List<Map<String, dynamic>>.from(
            responseBody['data']['notificationCategories'] ?? []),
      };

      return result;
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(
          errorResponse['errors'] ?? 'Failed to fetch notifications');
    }
  }
}
