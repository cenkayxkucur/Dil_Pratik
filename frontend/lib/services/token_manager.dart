import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

/// 401 Unauthorized geldiğinde tüm Dio instance'larının çağırdığı merkezi yönetici.
/// Önce refresh token ile yeni access token almayı dener.
/// Başarısız olursa oturumu kapatır.
class TokenManager {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static final _storage = const FlutterSecureStorage();
  static bool _isRefreshing = false;

  static Future<void> Function()? _onExpired;

  static void setOnExpired(Future<void> Function() callback) {
    _onExpired = callback;
  }

  static Future<bool> _tryRefresh() async {
    if (_isRefreshing) return false; // Çift çağrıyı önle
    _isRefreshing = true;
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode != 200) return false;

      final data =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final newToken = data['token'] as String?;
      final newRefresh = data['refresh_token'] as String?;
      if (newToken == null) return false;

      await _storage.write(key: _tokenKey, value: newToken);
      if (newRefresh != null) {
        await _storage.write(key: _refreshTokenKey, value: newRefresh);
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// 401 alındığında Dio interceptor'larından çağrılır.
  /// Önce refresh dener, başarısızsa oturumu kapatır.
  static Future<void> handleUnauthorized() async {
    final refreshed = await _tryRefresh();
    if (!refreshed) {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _onExpired?.call();
    }
  }
}
