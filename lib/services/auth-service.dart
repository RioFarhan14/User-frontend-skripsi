import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_frontend/utils/constants.dart';

class AuthService {
  static const String baseUrl = BASE_URL;

  Future<Map<String, dynamic>> login(
      String username, String password, String? fcmToken) async {
    final Uri url = Uri.parse('$baseUrl/api/users/login');
    Map<String, String> bodyData = {'username': username, 'password': password};

    if (fcmToken != null) {
      bodyData['fcm_token'] = fcmToken;
    }

    final response = await http.post(
      url,
      body: json.encode(bodyData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password,
      String confirmPassword, String name, String userPhone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      body: json.encode({
        'username': username,
        'password': password,
        'confirm_password': confirmPassword,
        'name': name,
        'user_phone': userPhone,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> updateUserData(
      String token, Map<String, dynamic> updatedData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/users/current'),
      body: json.encode(updatedData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token, // Mengirim token untuk autentikasi
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      print(
          'Error response: ${response.body}'); // Tambahkan ini untuk debugging
      throw Exception(errorResponse['errors'] ?? 'Update failed');
    }
  }

  Future<void> logout(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/users/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> getUserData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/current'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Registration failed');
    }
  }
}
