import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_frontend/services/auth-service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _token != null;

  final AuthService _authService = AuthService();

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> login(String username, String password, String? fcmToken) async {
    try {
      dynamic response;
      if (fcmToken != null) {
        response = await _authService.login(username, password, fcmToken);
      } else {
        response = await _authService.login(username, password, null);
      }

      _token = response['data']['token'];
      await fetchUserData(); // Ambil data pengguna setelah login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(String username, String password,
      String confirmPassword, String name, String userPhone) async {
    try {
      await _authService.register(
          username, password, confirmPassword, name, userPhone);
      await login(username, password, null);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      await fetchUserData();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    if (_token != null) {
      await _authService.logout(_token!);
    }
    _token = null;
    _userData = null; // Hapus data pengguna saat logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('fcm_token');
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    if (_token == null) return;
    try {
      final response = await _authService.getUserData(_token!);
      _userData = response['data'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (_token == null) return;
    try {
      final response = await _authService.updateUserData(_token!, updatedData);
      // Perbarui _userData dengan data terbaru dari response
      _userData = {
        ..._userData!,
        ...response['data'], // Menggabungkan data lama dengan yang baru
      };
      notifyListeners();
    } catch (error) {
      rethrow; // Tangani kesalahan update
    }
  }

  Map<String, dynamic>? get userData => _userData;
}
