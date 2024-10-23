import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_frontend/models/booking.dart';
import 'package:user_frontend/services/booking-service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<BookingItem> _userBookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingItem> get userBookings => _userBookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userBookings = await _bookingService.getUserBooking();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _userBookings = []; // Reset user bookings if there is an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<BookingItem>> fetchBookingsByDate(
      int productId, String bookingDate) async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<BookingItem> response =
          await _bookingService.getBookByDate(productId, bookingDate);
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BookingItem> getUserBookingById(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Periksa apakah daftar _userBookings sudah ada dan tidak kosong
      if (_userBookings.isEmpty) {
        throw Exception('Silahkan Booking terlebih dahulu');
      }

      // Cari booking berdasarkan id
      final booking = _userBookings.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception('Booking $id tidak ditemukan.'),
      );

      _errorMessage = null;
      return booking;
    } catch (e) {
      _errorMessage = e.toString();
      return Future.error(e); // Mengembalikan error jika terjadi kesalahan
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingUser(Map<String, dynamic> updateData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _bookingService.updateBookingData(updateData);

      // Pastikan 'data' adalah objek dan sesuaikan dengan struktur respons dari API
      final Map<String, dynamic> responseData = response['data'];

      // Menggunakan BookingItem dengan data yang diterima
      final updatedBooking =
          BookingItem.fromJsonWithoutClientName(responseData);

      // Perbarui booking yang sesuai dalam daftar _userBookings
      _userBookings = _userBookings.map((booking) {
        // Periksa apakah booking saat ini memiliki booking_id yang sama dengan yang diperbarui
        if (booking.id == updatedBooking.id) {
          // Jika sama, gunakan data baru
          return updatedBooking;
        }
        // Jika tidak sama, biarkan data seperti semula
        return booking;
      }).toList();

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow; // Re-throwing to handle the error in the UI if necessary
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
