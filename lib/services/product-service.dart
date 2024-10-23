import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/models/membership.dart';
import 'package:user_frontend/utils/constants.dart';

class ProductService {
  static const String baseUrl = BASE_URL;

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Field>> getAllField() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/products/field'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data.map((item) => Field.fromJson(item)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Failed to fetch fields');
    }
  }

  Future<List<Membership>> getAllMembership() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/products/membership'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data.map((item) => Membership.fromJson(item)).toList();
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Failed to fetch memberships');
    }
  }

  Future<Map<String, dynamic>> getProductById(String product) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/products?product_id=$product'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['errors'] ?? 'Failed to fetch product');
    }
  }
}
