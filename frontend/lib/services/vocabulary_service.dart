import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'token_manager.dart';

class SavedWord {
  final int id;
  final String word;
  final String? translation;
  final String? context;
  final DateTime? createdAt;

  const SavedWord({
    required this.id,
    required this.word,
    this.translation,
    this.context,
    this.createdAt,
  });

  factory SavedWord.fromJson(Map<String, dynamic> json) => SavedWord(
        id: json['id'] as int,
        word: json['word'] as String,
        translation: json['translation'] as String?,
        context: json['context'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
      );
}

class VocabularyService {
  final _storage = const FlutterSecureStorage();
  late final Dio _dio;

  VocabularyService() {
    _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await TokenManager.handleUnauthorized();
        }
        return handler.next(error);
      },
    ));
  }

  Future<List<SavedWord>> getSavedWords(String userId, String language) async {
    try {
      final response = await _dio.get(
        '/vocabulary/$userId',
        queryParameters: {'language': language},
      );
      final list = response.data['words'] as List? ?? [];
      return list
          .map((e) => SavedWord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> saveWord({
    required String userId,
    required String language,
    required String word,
    String? translation,
    String? context,
  }) async {
    try {
      await _dio.post(
        '/vocabulary/',
        data: {
          'user_id': userId,
          'language': language,
          'word': word,
          'translation': translation,
          'context': context,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteWord(int wordId, String userId) async {
    try {
      await _dio.delete(
        '/vocabulary/$wordId',
        queryParameters: {'user_id': userId},
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
