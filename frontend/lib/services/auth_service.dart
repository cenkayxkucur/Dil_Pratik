import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../models/user.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  String get _authBase => AppConfig.baseUrl;

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_authBase$path'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    final data = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 400) {
      final detail = data['detail'] ?? 'Bir hata oluştu';
      throw Exception(detail);
    }

    return data as Map<String, dynamic>;
  }

  Map<String, dynamic> _normalizeUser(Map<String, dynamic> raw) {
    return {
      'id': raw['id'],
      'email': raw['email'],
      'username': raw['username'],
      'isActive': raw['is_active'] ?? raw['isActive'] ?? true,
      'createdAt': raw['created_at'] ?? raw['createdAt'] ?? DateTime.now().toIso8601String(),
      'updatedAt': raw['updated_at'] ?? raw['updatedAt'],
    };
  }

  Future<({User user, String token})> signIn(String email, String password) async {
    final data = await _post('/auth/login', {
      'email': email,
      'password': password,
    });

    final user = User.fromJson(_normalizeUser(data['user'] as Map<String, dynamic>));
    final token = data['token'] as String;
    await _storage.write(key: _tokenKey, value: token);
    return (user: user, token: token);
  }

  Future<({User user, String token})> signUp(
    String email,
    String password,
    String username,
  ) async {
    final data = await _post('/auth/register', {
      'email': email,
      'password': password,
      'username': username,
    });

    final user = User.fromJson(_normalizeUser(data['user'] as Map<String, dynamic>));
    final token = data['token'] as String;
    await _storage.write(key: _tokenKey, value: token);
    return (user: user, token: token);
  }

  Future<void> signOut() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Saklı token ile mevcut kullanıcıyı getirir.
  /// Token yoksa veya geçersizse null döner.
  Future<User?> getMe() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return null;

    final response = await http.get(
      Uri.parse('$_authBase/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401 || response.statusCode == 404) {
      await _storage.delete(key: _tokenKey); // geçersiz token, temizle
      return null;
    }
    if (response.statusCode >= 400) return null;

    final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return User.fromJson(_normalizeUser(data['user'] as Map<String, dynamic>));
  }
}
