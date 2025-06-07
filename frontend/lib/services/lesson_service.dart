import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/lesson.dart';

class LessonService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _backendUrl =
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  Future<List<Lesson>> getLessons() async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$_backendUrl/lessons'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch lessons');
      }

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Lesson.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch lessons: $e');
    }
  }

  Future<LessonContent> getLessonContent(int lessonId) async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$_backendUrl/lessons/$lessonId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch lesson content');
      }

      final data = json.decode(response.body);
      return LessonContent.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch lesson content: $e');
    }
  }

  Future<Lesson> createLesson(String language, String difficulty,
      {String? topic}) async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$_backendUrl/lessons'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'language': language,
          'difficulty': difficulty,
          'topic': topic,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create lesson');
      }

      final data = json.decode(response.body);
      return Lesson.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create lesson: $e');
    }
  }

  Future<String> generateSpeech(String text, String languageCode) async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$_backendUrl/tts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': text,
          'language_code': languageCode,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate speech');
      }

      final data = json.decode(response.body);
      return data['audio_url'];
    } catch (e) {
      throw Exception('Failed to generate speech: $e');
    }
  }
}
