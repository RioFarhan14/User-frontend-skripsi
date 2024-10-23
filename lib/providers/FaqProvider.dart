import 'package:flutter/material.dart';
import 'package:user_frontend/services/faq-service.dart';

class FaqProvider with ChangeNotifier {
  final FaqService _faqService;

  FaqProvider(this._faqService);

  bool _isLoading = false;
  List<Map<String, dynamic>> _faqs = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get faqs => _faqs;
  String? get errorMessage => _errorMessage;

  // Mengambil FAQ dari FaqService
  Future<void> fetchFaqs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _faqService.getFaq();
      // Mengonversi data yang diterima menjadi List<Map<String, dynamic>>
      _faqs = List<Map<String, dynamic>>.from(response['data']);
    } catch (e) {
      // Menangani kesalahan dan menyimpan pesan kesalahan
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
