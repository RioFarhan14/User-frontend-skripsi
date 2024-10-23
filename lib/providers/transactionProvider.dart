import 'package:flutter/material.dart';
import 'package:user_frontend/services/transaction-service.dart';

class TransactionProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>>? _transactions;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>>? get transactions => _transactions;

  final TransactionService _service;

  TransactionProvider(this._service);

  Future<Map<String, dynamic>?> createTransaction(
      Map<String, dynamic> args) async {
    _isLoading = true;
    notifyListeners();

    try {
      final transaction = await _service.createTransaction(args);
      return transaction['data'];
    } catch (e) {
      // Handle error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserHistoryTransaction() async {
    _isLoading = true;
    notifyListeners();

    try {
      final transaction = await _service.getUserTransaction();
      final List<dynamic> data = transaction['data'];

      // Mengonversi List<dynamic> menjadi List<Map<String, dynamic>>
      _transactions = data.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      _transactions = [];
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
