import 'dart:convert';
import 'package:user_frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FaqService {
  static const String baseUrl = BASE_URL;

  // Mendapatkan token dari SharedPreferences
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Mendapatkan FAQ dari server
  Future<Map<String, dynamic>> getFaq() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    // Melakukan request HTTP GET untuk mendapatkan FAQ
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/users/help'), // Ubah endpoint sesuai dengan API Anda
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    // Menangani response dari server
    if (response.statusCode == 200) {
      // Mengonversi response body ke dalam format JSON
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      // Menangani kesalahan jika status code tidak 200
      throw Exception(errorResponse['errors'] ?? 'Gagal mendapatkan data FAQ');
    }
  }
}
