import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/user_session_service.dart';

// Simple auth state provider without Firebase
final authStateProvider = StateProvider<User?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthController(this._ref) : super(const AsyncValue.data(null)) {
    // AuthService can be initialized when needed
  }
  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      // For now, create a mock user for testing
      final user = User(
        id: 1,
        email: email,
        username: 'Test User',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _ref.read(authStateProvider.notifier).state = user;
      state = AsyncValue.data(user);
      
      // Handle user session transition
      UserSessionService.onUserSignIn(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  Future<void> signUp(String email, String password, String username) async {
    try {
      state = const AsyncValue.loading();
      // For now, create a mock user for testing
      final user = User(
        id: 2,
        email: email,
        username: username,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _ref.read(authStateProvider.notifier).state = user;
      state = AsyncValue.data(user);
      
      // Handle user session transition
      UserSessionService.onUserSignIn(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  Future<void> signOut() async {
    try {
      _ref.read(authStateProvider.notifier).state = null;
      state = const AsyncValue.data(null);
      
      // Handle user session transition
      UserSessionService.onUserSignOut();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = const AsyncValue.loading();
      // Mock password reset - in real app would call backend
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
