import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 401 Unauthorized geldiğinde tüm Dio instance'larının çağırdığı merkezi yönetici.
/// Service katmanını Riverpod'dan bağımsız tutar.
class TokenManager {
  static const _tokenKey = 'auth_token';
  static final _storage = FlutterSecureStorage();

  /// Uygulama başlatıldığında (MyApp) set edilir.
  static Future<void> Function()? _onExpired;

  /// MyApp tarafından bir kez çağrılır.
  static void setOnExpired(Future<void> Function() callback) {
    _onExpired = callback;
  }

  /// 401 alındığında Dio interceptor'larından çağrılır.
  /// Token'ı siler, auth callback'i tetikler.
  static Future<void> handleUnauthorized() async {
    await _storage.delete(key: _tokenKey);
    await _onExpired?.call();
  }
}
