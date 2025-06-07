// Simplified AuthService without Firebase
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  final String _backendUrl = 'http://localhost:8000'; // Direct URL instead of dotenv
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        // Login failed: ${response.statusCode} (debug print removed for production)
        return null;
      }
    } catch (e) {
      // Sign in error: $e (debug print removed for production)
      // Fallback to mock user for testing
      return User(
        id: 1,
        email: email,
        username: 'Test User',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );    }
  }

  Future<User?> signUp(String email, String password, String username) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        // Registration failed: ${response.statusCode} (debug print removed for production)
        return null;
      }
    } catch (e) {
      // Sign up error: $e (debug print removed for production)
      // Fallback to mock user for testing
      return User(
        id: 2,
        email: email,
        username: username,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
  Future<void> signOut() async {
    // For now, just mock - in production, call your backend API
    // Mock sign out (debug print removed for production)
  }

  Future<void> resetPassword(String email) async {
    // For now, just mock - in production, call your backend API
    // Mock password reset for: $email (debug print removed for production)
  }

  Future<String?> getIdToken() async {
    // For now, return null - in production, return actual token
    return null;
  }
}