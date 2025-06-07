// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  // Backend URL is now hardcoded for simplicity
  static const String backendUrl = 'http://localhost:8000';
  Future<User?> signIn(String email, String password) async {
    try {
      // For now, return a mock user - in production, call your backend API
      // Mock sign in for: $email (debug print removed for production)
      return User(
        id: 1,
        email: email,
        username: 'Test User',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: Replace with actual backend call
      // final response = await http.post(
      //   Uri.parse('$_backendUrl/api/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );
      // 
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return User.fromJson(data['user']);
      // } else {
      //   throw Exception('Failed to authenticate');
      // }
    } catch (e) {
      rethrow;
    }
  }
  Future<User?> signUp(String email, String password, String username) async {
    try {
      // For now, return a mock user - in production, call your backend API
      // Mock sign up for: $email (debug print removed for production)
      return User(
        id: 2,
        email: email,
        username: username,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: Replace with actual backend call
      // final response = await http.post(
      //   Uri.parse('$_backendUrl/api/auth/register'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'username': username,
      //     'password': password,
      //   }),
      // );
      // 
      // if (response.statusCode == 201) {
      //   final data = json.decode(response.body);
      //   return User.fromJson(data['user']);
      // } else {
      //   throw Exception('Failed to register');
      // }
    } catch (e) {
      rethrow;
    }
  }
  Future<void> signOut() async {
    // For now, just mock - in production, call your backend API
    // Mock sign out (debug print removed for production)
    
    // TODO: Replace with actual backend call if needed
    // await http.post(
    //   Uri.parse('$_backendUrl/api/auth/logout'),
    //   headers: {'Content-Type': 'application/json'},
    // );
  }
  Future<void> resetPassword(String email) async {
    // For now, just mock - in production, call your backend API
    // Mock password reset for: $email (debug print removed for production)
    
    // TODO: Replace with actual backend call
    // await http.post(
    //   Uri.parse('$_backendUrl/api/auth/reset-password'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({'email': email}),
    // );
  }

  Future<String?> getIdToken() async {
    // For now, return null - in production, return actual token
    return null;
  }
}
