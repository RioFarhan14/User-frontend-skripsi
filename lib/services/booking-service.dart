import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:user_frontend/models/booking.dart';
import 'package:user_frontend/utils/constants.dart';

class BookingService {
  static const String baseUrl = BASE_URL;

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<BookingItem>> getUserBooking() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/current/booking'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data
          .map((item) => BookingItem.fromJsonWithoutClientName(item))
          .toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(
          errorResponse['errors'] ?? 'Gagal mengambil data booking');
    }
  }

  Future<List<BookingItem>> getBookByDate(
      int productId, String bookingDate) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/users/bookings?product_id=$productId&booking_date=$bookingDate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data
          .map((item) => BookingItem.fromJsonWithClientName(item))
          .toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(
          errorResponse['errors'] ?? 'Gagal mengambil data booking');
    }
  }

  Future<Map<String, dynamic>> updateBookingData(
      Map<String, dynamic> updatedData) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.patch(
      Uri.parse('$baseUrl/api/users/booking'),
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
}
