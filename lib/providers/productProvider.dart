import 'package:flutter/material.dart';
import 'package:user_frontend/models/field.dart';
import 'package:user_frontend/models/membership.dart';
import 'package:user_frontend/services/product-service.dart';
import 'package:collection/collection.dart';

class ProductProvider with ChangeNotifier {
  List<Field> _fields = [];
  List<Membership> _memberships = [];
  bool _isLoading = false;

  List<Field> get fields => _fields;
  List<Membership> get memberships => _memberships;
  bool get isLoading => _isLoading;

  final ProductService _service;

  ProductProvider(this._service);

  /// Mengambil data berdasarkan ID. Jika ID ditemukan, mengembalikan Field atau Membership
  Object? getDataById(int id) {
    try {
      // Coba ambil data dari fields terlebih dahulu
      final field = _fields.firstWhereOrNull((field) => field.id == id);
      if (field != null) {
        return field;
      }

      // Jika tidak ditemukan di fields, coba ambil dari memberships
      final membership =
          _memberships.firstWhereOrNull((membership) => membership.id == id);
      if (membership != null) {
        return membership;
      }

      // Jika tidak ditemukan di keduanya, kembalikan null
      print('Data with ID $id not found');
      return null;
    } catch (e) {
      // Penanganan error jika ada exception lain
      print('Error retrieving data by ID: $e');
      return null; // Mengembalikan null jika terjadi error
    }
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _fields = await _service.getAllField();
      _memberships = await _service.getAllMembership();
    } catch (e) {
      // Menangani error pengambilan data
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
