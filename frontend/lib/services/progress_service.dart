import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/progress.dart';

class ProgressService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _backendUrl =
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  Future<List<Progress>> getProgress() async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$_backendUrl/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch progress');
      }

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Progress.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch progress: $e');
    }
  }

  Future<Progress> createProgress(
      int lessonId, double score, bool completed) async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$_backendUrl/progress'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'lesson_id': lessonId,
          'score': score,
          'completed': completed,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create progress');
      }

      final data = json.decode(response.body);
      return Progress.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create progress: $e');
    }
  }

  Future<Progress?> getLessonProgress(int lessonId) async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$_backendUrl/progress/$lessonId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch lesson progress');
      }

      final data = json.decode(response.body);
      return Progress.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch lesson progress: $e');
    }
  }
}
