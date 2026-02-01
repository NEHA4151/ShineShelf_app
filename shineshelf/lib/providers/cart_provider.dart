import 'package:flutter/material.dart';
import '../models/book.dart';

class CartProvider with ChangeNotifier {
  List<Book> _items = [];

  List<Book> get items => _items;

  double get totalAmount {
    var total = 0.0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }

  void addToCart(Book book) {
    _items.add(book);
    notifyListeners();
  }

  void removeFromCart(Book book) {
    _items.remove(book);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
