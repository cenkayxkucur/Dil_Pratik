import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class UserSessionService {
  static String? _currentUserId;
  static WidgetRef? _ref;
  
  /// Initialize the service with Riverpod reference for auth state access
  static void initialize(WidgetRef ref) {
    _ref = ref;
  }
  
  /// Get user ID based on authentication status
  static String getCurrentUserId() {
    // Try to get authenticated user ID first
    if (_ref != null) {
      final authState = _ref!.read(authStateProvider);
      if (authState != null) {
        // Use authenticated user's database ID with prefix for clarity
        return 'auth_user_${authState.id}';
      }
    }
    
    // Fallback to session-based ID for anonymous users
    if (_currentUserId == null) {
      // Generate a unique session-based user ID
      final random = Random();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = random.nextInt(10000);
      _currentUserId = 'anon_user_${timestamp}_$randomSuffix';
    }
    return _currentUserId!;
  }
  
  /// Check if current user is authenticated
  static bool isAuthenticatedUser() {
    if (_ref != null) {
      final authState = _ref!.read(authStateProvider);
      return authState != null;
    }
    return false;
  }
  
  /// Get the authenticated user object if available
  static User? getAuthenticatedUser() {
    if (_ref != null) {
      return _ref!.read(authStateProvider);
    }
    return null;
  }
  
  /// Clear the current session (for sign out or testing)
  static void clearSession() {
    _currentUserId = null;
  }
  
  /// Set a specific user ID (for authenticated users or testing)
  static void setUserId(String userId) {
    _currentUserId = userId;
  }
  
  /// Handle user sign in - switch from anonymous to authenticated ID
  static void onUserSignIn(User user) {
    // Optionally migrate conversation history from anonymous session
    // to authenticated user (this would require backend support)
    final oldSessionId = _currentUserId;
    _currentUserId = null; // Reset to get new authenticated ID
    
    // Session geçişi tamamlandı (oldSessionId -> authenticated ID)
  }
  
  /// Handle user sign out - switch to new anonymous session
  static void onUserSignOut() {
    _currentUserId = null; // This will generate a new anonymous ID on next call
  }
}
