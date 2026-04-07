import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../models/user.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../models/language.dart';
import '../models/structured_lesson.dart';
import 'user_session_service.dart';

class ApiService {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
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

  // New lesson methods for the updated system
  Future<Map<String, dynamic>> getLessonsByFilter({
    String? language,
    String? level,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (language != null) queryParams['language'] = language;
      if (level != null) queryParams['level'] = level;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _dio.get('/lessons/', queryParameters: queryParams);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getLessonById(int lessonId) async {
    try {
      final response = await _dio.get('/lessons/$lessonId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    try {
      final response = await _dio.get('/lessons/metadata/languages');
      return List<String>.from(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> getAvailableLevels(String language) async {
    try {
      final response = await _dio.get('/lessons/metadata/levels/$language');
      return List<String>.from(response.data);
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
    String? communicationLanguage,
  }) async {
    try {
      final data = {
        'message': message,
        'language': language,
        'level': level,
        'user_id': userId,
      };
      
      // Add communication language if provided
      if (communicationLanguage != null) {
        data['communication_language'] = communicationLanguage;
      }
      
      final response = await _dio.post('/ai/chat', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  Future<Map<String, dynamic>> analyzeGrammar({
    required String text,
    required String language,
    required String level,
  }) async {
    try {
      final response = await _dio.post(
        '/ai/analyze-grammar',
        data: {
          'text': text,
          'language': language,
          'level': level,
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
  }  Future<Map<String, dynamic>> clearConversationHistory(String userId) async {
    try {
      final response = await _dio.delete('/ai/conversation-history/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  // New method to support the practice screen with enhanced parameters
  static Future<String> getChatResponse(
    String message, 
    Language? selectedLanguage, {
    LanguageLevel? level,
    Language? communicationLanguage,
  }) async {
    try {
      final apiService = ApiService();
      final response = await apiService.chatWithAI(
        message: message,
        language: selectedLanguage?.code ?? 'turkish',
        level: level?.name ?? 'A1',
        userId: UserSessionService.getCurrentUserId(), // Uses auth user ID if authenticated, session ID if anonymous
        communicationLanguage: communicationLanguage?.code,
      );

      if (response['success'] == true) {
        return response['response'] as String;
      } else {
        throw Exception('AI chat failed');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Structured Lesson API Methods
  Future<List<String>> getStructuredLanguages() async {
    try {
      final response = await _dio.get('/v2/languages');
      return List<String>.from(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, String>>> getStructuredLevelsForLanguage(String language) async {
    try {
      final response = await _dio.get('/v2/languages/$language/levels');
      return List<Map<String, String>>.from(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<LanguageLevelWithTopics> getLanguageLevelWithTopics(String language, String level) async {
    try {
      final response = await _dio.get('/v2/languages/$language/levels/$level');
      return LanguageLevelWithTopics.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<GrammarTopicWithLessons> getGrammarTopicWithLessons(int topicId) async {
    try {
      final response = await _dio.get('/v2/topics/$topicId');
      return GrammarTopicWithLessons.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<StructuredLessonResponse> getStructuredLesson(int lessonId) async {
    try {
      final response = await _dio.get('/v2/lessons/$lessonId');
      return StructuredLessonResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<LanguageLessonsResponse> getLanguageLessons({
    required String language,
    String? level,
    int? topicId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };
      if (level != null) queryParams['level'] = level;
      if (topicId != null) queryParams['topic_id'] = topicId;

      final response = await _dio.get('/v2/languages/$language/lessons', queryParameters: queryParams);
      return LanguageLessonsResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Lesson Chat API Method
  Future<String> lessonChat({
    required String message,
    required int lessonId,
    required String lessonContent,
    required String lessonTitle,
    required String language,
    required String level,
    String? userId,
    String? communicationLanguage,
  }) async {
    try {
      final response = await _dio.post('/ai/lesson-chat', data: {
        'message': message,
        'lesson_id': lessonId,
        'lesson_content': lessonContent,
        'lesson_title': lessonTitle,
        'user_id': userId ?? 'anonymous_user',
        'language': language,
        'level': level,
        if (communicationLanguage != null) 'communication_language': communicationLanguage,
      });
      
      return response.data['response'] ?? 'Yanıt alınamadı';
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
