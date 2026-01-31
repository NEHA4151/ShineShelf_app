import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await _apiService.get('/books');
      _books = response.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      print('Fetch Books Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
