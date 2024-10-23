import 'dart:convert';

import 'package:user_frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  static const String baseUrl = BASE_URL;
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> createTransaction(
      Map<String, dynamic> data) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/transaction'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token, // Mengirim token untuk autentikasi
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);

      throw Exception(errorResponse['errors'] ?? 'Update failed');
    }
  }

  Future<Map<String, dynamic>> getUserTransaction() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/current/transaction'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token, // Mengirim token untuk autentikasi
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);

      throw Exception(errorResponse['errors'] ?? 'Update failed');
    }
  }
}
