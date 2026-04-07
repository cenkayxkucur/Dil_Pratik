import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'token_manager.dart';

class LearningProfile {
  final int totalInteractions;
  final List<GrammarArea> weakGrammar;
  final List<GrammarArea> strongGrammar;
  final List<VocabArea> weakVocabulary;
  final List<VocabArea> strongVocabulary;
  final List<String> frequentTopics;

  const LearningProfile({
    required this.totalInteractions,
    required this.weakGrammar,
    required this.strongGrammar,
    required this.weakVocabulary,
    required this.strongVocabulary,
    required this.frequentTopics,
  });

  factory LearningProfile.empty() => const LearningProfile(
        totalInteractions: 0,
        weakGrammar: [],
        strongGrammar: [],
        weakVocabulary: [],
        strongVocabulary: [],
        frequentTopics: [],
      );

  factory LearningProfile.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(
      dynamic raw,
      T Function(Map<String, dynamic>) fromJson,
    ) {
      if (raw == null) return [];
      return (raw as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }

    return LearningProfile(
      totalInteractions: json['total_interactions'] as int? ?? 0,
      weakGrammar: parseList(json['weak_grammar'], GrammarArea.fromJson),
      strongGrammar: parseList(json['strong_grammar'], GrammarArea.fromJson),
      weakVocabulary: parseList(json['weak_vocabulary'], VocabArea.fromJson),
      strongVocabulary: parseList(json['strong_vocabulary'], VocabArea.fromJson),
      frequentTopics: (json['frequent_topics'] as List? ?? []).cast<String>(),
    );
  }
}

class GrammarArea {
  final String code;
  final String display;
  final double errorRate;
  final int count;

  const GrammarArea({
    required this.code,
    required this.display,
    required this.errorRate,
    required this.count,
  });

  factory GrammarArea.fromJson(Map<String, dynamic> json) => GrammarArea(
        code: json['code'] as String,
        display: json['display'] as String,
        errorRate: (json['error_rate'] as num).toDouble(),
        count: json['count'] as int? ?? 0,
      );

  double get successRate => 1.0 - errorRate;
}

class VocabArea {
  final String word;
  final double errorRate;

  const VocabArea({required this.word, required this.errorRate});

  factory VocabArea.fromJson(Map<String, dynamic> json) => VocabArea(
        word: json['word'] as String,
        errorRate: (json['error_rate'] as num).toDouble(),
      );
}

class DayActivity {
  final String date;
  final int count;
  final double? avgScore;

  const DayActivity({
    required this.date,
    required this.count,
    this.avgScore,
  });

  factory DayActivity.fromJson(Map<String, dynamic> json) => DayActivity(
        date: json['date'] as String,
        count: json['count'] as int? ?? 0,
        avgScore: json['avg_score'] != null
            ? (json['avg_score'] as num).toDouble()
            : null,
      );
}

class ReviewWord {
  final String word;
  final int incorrect;
  final int correct;
  final double errorRate;
  final DateTime? nextReviewAt;

  const ReviewWord({
    required this.word,
    required this.incorrect,
    required this.correct,
    required this.errorRate,
    this.nextReviewAt,
  });

  factory ReviewWord.fromJson(Map<String, dynamic> json) => ReviewWord(
        word: json['word'] as String,
        incorrect: json['incorrect'] as int? ?? 0,
        correct: json['correct'] as int? ?? 0,
        errorRate: (json['error_rate'] as num).toDouble(),
        nextReviewAt: json['next_review_at'] != null
            ? DateTime.tryParse(json['next_review_at'] as String)
            : null,
      );
}

class ReviewGrammar {
  final String code;
  final String display;
  final double errorRate;
  final int incorrect;
  final int correct;
  final String level;

  const ReviewGrammar({
    required this.code,
    required this.display,
    required this.errorRate,
    required this.incorrect,
    required this.correct,
    required this.level,
  });

  factory ReviewGrammar.fromJson(Map<String, dynamic> json) => ReviewGrammar(
        code: json['code'] as String,
        display: json['display'] as String,
        errorRate: (json['error_rate'] as num).toDouble(),
        incorrect: json['incorrect'] as int? ?? 0,
        correct: json['correct'] as int? ?? 0,
        level: json['level'] as String? ?? '',
      );
}

class ReviewQueue {
  final List<ReviewWord> dueWords;
  final List<ReviewGrammar> weakGrammar;
  final List<ReviewWord> weakVocabulary;

  const ReviewQueue({
    required this.dueWords,
    required this.weakGrammar,
    required this.weakVocabulary,
  });

  factory ReviewQueue.empty() => const ReviewQueue(
        dueWords: [],
        weakGrammar: [],
        weakVocabulary: [],
      );

  bool get isEmpty =>
      dueWords.isEmpty && weakGrammar.isEmpty && weakVocabulary.isEmpty;

  factory ReviewQueue.fromJson(Map<String, dynamic> json) {
    List<T> parse<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
      if (raw == null) return [];
      return (raw as List).map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }

    return ReviewQueue(
      dueWords: parse(json['due_words'], ReviewWord.fromJson),
      weakGrammar: parse(json['weak_grammar'], ReviewGrammar.fromJson),
      weakVocabulary: parse(json['weak_vocabulary'], ReviewWord.fromJson),
    );
  }
}

class ProgressService {
  final _storage = const FlutterSecureStorage();
  late final Dio _dio;

  ProgressService() {
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

  Future<LearningProfile> getProfile(String userId, String language) async {
    try {
      final response = await _dio.get(
        '/ai/profile/$userId',
        queryParameters: {'language': language},
      );
      return LearningProfile.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return LearningProfile.empty();
    }
  }

  Future<ReviewQueue> getReviewQueue(String userId, String language) async {
    try {
      final response = await _dio.get(
        '/ai/review-queue/$userId',
        queryParameters: {'language': language},
      );
      return ReviewQueue.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return ReviewQueue.empty();
    }
  }

  Future<List<DayActivity>> getActivity(
    String userId,
    String language, {
    int days = 7,
  }) async {
    try {
      final response = await _dio.get(
        '/ai/activity/$userId',
        queryParameters: {'language': language, 'days': days},
      );
      final list = (response.data['days'] as List? ?? []);
      return list.map((e) => DayActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return List.generate(
        days,
        (i) => DayActivity(
          date: DateTime.now()
              .subtract(Duration(days: days - 1 - i))
              .toIso8601String()
              .substring(0, 10),
          count: 0,
        ),
      );
    }
  }
}
