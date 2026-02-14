import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiService {
  // Use localhost for Web/Windows/iOS, 10.0.2.2 for Android Emulator
  // Replace this with your computer's Wi-Fi IP Address (run 'ipconfig' to find it)
  static const String _localPcIp = '172.20.32.137';

  static String get baseUrl {
    if (kIsWeb) {
      // Use localhost for Web
      return 'http://localhost:3000'; 
    }
    try {
      if (Platform.isAndroid) {
        // '10.0.2.2' is for the Android Emulator.
        // For physical device, use the PC's IP. 
        // We will try the LAN IP first as it works for both if configured, 
        // but '10.0.2.2' is safer for Emulators.
        // Uncomment the one you need.
        // return 'http://10.0.2.2:3000'; // Emulator
        return 'http://$_localPcIp:3000'; // Physical Phone
      }
    } catch (e) {
      return 'http://localhost:3000';
    }
    return 'http://localhost:3000';
  }

  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
