import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../models/lesson.dart';
import '../models/progress.dart';

class ApiService {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8000/api',
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/token',
        data: {'username': username, 'password': password},
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );

      final token = response.data['access_token'];
      await _storage.write(key: 'token', value: token);
      return token;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> register(String email, String username, String password) async {
    try {
      final response = await _dio.post(
        '/users/',
        data: {'email': email, 'username': username, 'password': password},
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me/');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Lesson>> getLessons() async {
    try {
      final response = await _dio.get('/lessons/');
      return (response.data as List)
          .map((json) => Lesson.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<LessonContent> generateLesson(
    String language,
    String difficulty, {
    String? topic,
  }) async {
    try {
      final response = await _dio.post(
        '/lessons/generate/',
        queryParameters: {
          'language': language,
          'difficulty': difficulty,
          if (topic != null) 'topic': topic,
        },
      );
      return LessonContent.fromJson(jsonDecode(response.data));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> generateSpeech(String text, String languageCode) async {
    try {
      final response = await _dio.post(
        '/speech/generate/',
        queryParameters: {'text': text, 'language_code': languageCode},
      );
      return response.data['audio_url'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Progress> saveProgress(ProgressCreate progress) async {
    try {
      final response = await _dio.post('/progress/', data: progress.toJson());
      return Progress.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }
  Future<Evaluation> evaluateAnswer(
    String userAnswer,
    String correctAnswer,
    String language,
  ) async {
    try {
      final response = await _dio.post(
        '/evaluate/',
        queryParameters: {
          'user_answer': userAnswer,
          'correct_answer': correctAnswer,
          'language': language,
        },
      );
      return Evaluation.fromJson(jsonDecode(response.data));
    } catch (e) {
      throw _handleError(e);
    }
  }

  // AI Chat endpoints
  Future<Map<String, dynamic>> chatWithAI({
    required String message,
    required String language,
    required String level,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/chat',
        data: {
          'message': message,
          'language': language,
          'level': level,
          'user_id': userId,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> analyzeGrammar({
    required String text,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/analyze-grammar',
        data: {
          'text': text,
          'language': language,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> generatePracticeContent({
    required String topic,
    required String language,
    required String level,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/generate-practice',
        data: {
          'topic': topic,
          'language': language,
          'level': level,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getConversationHistory(String userId) async {
    try {
      final response = await _dio.get('/ai/conversation-history/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> clearConversationHistory(String userId) async {
    try {
      final response = await _dio.delete('/ai/conversation-history/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response!.data;
        if (data is Map && data.containsKey('detail')) {
          return Exception(data['detail']);
        }
        return Exception(error.response!.statusMessage);
      }
      return Exception(error.message);
    }
    return Exception('An unexpected error occurred');
  }
}
