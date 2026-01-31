import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      String token = response['token'];
      await _apiService.saveToken(token);
      _user = User.fromJson(response['user']);
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
      });
      // Automatically login after register or just inform user?
      // For now, let's just finish the function.
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }
}
