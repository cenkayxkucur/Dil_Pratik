import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Basit TTL-tabanlı JSON cache.
/// SharedPreferences üzerine inşa edilmiştir.
class CacheService {
  static const Duration defaultTtl = Duration(minutes: 30);

  /// [key] ile kaydedilmiş veriyi döndürür.
  /// TTL dolmuşsa veya veri yoksa null döner.
  Future<T?> get<T>(
    String key,
    T Function(dynamic json) fromJson, {
    Duration ttl = defaultTtl,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;

      final map = json.decode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(map['cached_at'] as String);
      if (DateTime.now().difference(cachedAt) > ttl) return null;

      return fromJson(map['data']);
    } catch (_) {
      return null;
    }
  }

  /// Veriyi [key] ile kaydeder.
  Future<void> set(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        key,
        json.encode({
          'data': data,
          'cached_at': DateTime.now().toIso8601String(),
        }),
      );
    } catch (_) {}
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));
    for (final k in keys) {
      await prefs.remove(k);
    }
  }
}

// Cache key sabitleri
class CacheKeys {
  static String levelTopics(String language, String level) =>
      'cache_level_topics_${language}_$level';
  static String topicLessons(int topicId) => 'cache_topic_lessons_$topicId';
  static String learningProfile(String userId, String language) =>
      'cache_profile_${userId}_$language';
  static String streak(String userId, String language) =>
      'cache_streak_${userId}_$language';
}
