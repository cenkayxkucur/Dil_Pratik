import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_session_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Giriş yapmış kullanıcı; null ise oturum açılmamış demektir.
final authStateProvider = StateProvider<User?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthController(this._ref) : super(const AsyncValue.loading()) {
    _restoreSession();
  }

  AuthService get _service => _ref.read(authServiceProvider);

  /// Uygulama başlangıcında kayıtlı token ile /auth/me'yi çağırır.
  /// Başarılıysa kullanıcıyı yükler, değilse token'ı temizler.
  Future<void> _restoreSession() async {
    try {
      final user = await _service.getMe();
      _ref.read(authStateProvider.notifier).state = user;
      state = AsyncValue.data(user);
      if (user != null) UserSessionService.onUserSignIn(user);
    } catch (_) {
      _ref.read(authStateProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.signIn(email, password);
      _ref.read(authStateProvider.notifier).state = result.user;
      state = AsyncValue.data(result.user);
      UserSessionService.onUserSignIn(result.user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.signUp(email, password, username);
      _ref.read(authStateProvider.notifier).state = result.user;
      state = AsyncValue.data(result.user);
      UserSessionService.onUserSignIn(result.user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _service.signOut();
      _ref.read(authStateProvider.notifier).state = null;
      state = const AsyncValue.data(null);
      UserSessionService.onUserSignOut();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
