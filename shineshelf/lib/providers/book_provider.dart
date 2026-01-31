import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  List<Book> _myBooks = [];
  List<Book> get myBooks => _myBooks;

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

  Future<bool> borrowBook(int bookId) async {
    try {
      await _apiService.post('/transactions/borrow', {'bookId': bookId});
      await fetchMyBooks(); // Refresh my books
      return true;
    } catch (e) {
      print('Borrow Error: $e');
      return false;
    }
  }

  Future<bool> returnBook(int bookId) async {
    try {
      await _apiService.post('/transactions/return', {'bookId': bookId});
      await fetchMyBooks(); // Refresh my books
      return true;
    } catch (e) {
      print('Return Error: $e');
      return false;
    }
  }

  Future<void> fetchMyBooks() async {
    try {
      final List<dynamic> response = await _apiService.get('/transactions/my-books');
      _myBooks = response.map((json) => Book.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Fetch My Books Error: $e');
    }
  }
}
