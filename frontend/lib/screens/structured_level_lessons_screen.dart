import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/language.dart';
import '../models/structured_lesson.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../widgets/state_template.dart';
import '../widgets/lesson_chat_widget.dart';
import 'exercise_screen.dart';

class StructuredLevelLessonsScreen extends ConsumerWidget {
  final Language language;
  final LanguageLevel level;

  const StructuredLevelLessonsScreen({
    super.key,
    required this.language,
    required this.level,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelTopicsAsync = ref.watch(_levelTopicsProvider((language.code, level.code)));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${language.flag} ${language.name} - ${level.displayName}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StateTemplate<LanguageLevelWithTopics>(
        asyncValue: levelTopicsAsync,
        emptyMessage: 'Bu seviyede henüz konu bulunmuyor.\nYakında yeni konular eklenecek!',
        errorTitle: 'Konular Yüklenemedi',
        onRetry: () => ref.refresh(_levelTopicsProvider((language.code, level.code))),
        dataBuilder: (levelWithTopics) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: levelWithTopics.grammarTopics.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final topic = levelWithTopics.grammarTopics[index];
            return _TopicCard(
              topic: topic,
              onTap: () => _navigateToTopicLessons(context, topic),
            );
          },
        ),
      ),
    );
  }

  void _navigateToTopicLessons(BuildContext context, GrammarTopicResponse topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicLessonsScreen(
          language: language,
          level: level,
          topic: topic,
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final GrammarTopicResponse topic;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book_outlined,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (topic.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        topic.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicLessonsScreen extends ConsumerWidget {
  final Language language;
  final LanguageLevel level;
  final GrammarTopicResponse topic;

  const TopicLessonsScreen({
    super.key,
    required this.language,
    required this.level,
    required this.topic,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicLessonsAsync = ref.watch(_topicLessonsProvider(topic.id));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          StateTemplate<GrammarTopicWithLessons>(
            asyncValue: topicLessonsAsync,
            emptyMessage: 'Bu konuda henüz ders bulunmuyor.\nYakında yeni dersler eklenecek!',
            errorTitle: 'Dersler Yüklenemedi',
            onRetry: () => ref.refresh(_topicLessonsProvider(topic.id)),
            dataBuilder: (topicWithLessons) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: topicWithLessons.lessons.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = topicWithLessons.lessons[index];
                return _LessonCard(
                  lesson: lesson, 
                  language: language, 
                  level: level,
                );
              },
            ),
          ),
          
          // Chat Widget for current lessons
          if (topicLessonsAsync.hasValue && topicLessonsAsync.value!.lessons.isNotEmpty)
            LessonChatWidget(
              lesson: topicLessonsAsync.value!.lessons.first, // Use first lesson as context
              language: language.code,
              level: level.code,
            ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatefulWidget {
  final StructuredLessonResponse lesson;
  final Language language;
  final LanguageLevel level;

  const _LessonCard({
    required this.lesson,
    required this.language,
    required this.level,
  });

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.school_outlined,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lesson.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.lesson.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.lesson.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lesson.content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseScreen(
                            lessonContent: widget.lesson.content,
                            lessonTitle: widget.lesson.title,
                            language: widget.language.code,
                            level: widget.level.code,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.quiz_outlined, size: 18),
                      label: const Text('Egzersiz Yap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Providers (cache destekli)
final _cacheServiceProvider = Provider<CacheService>((ref) => CacheService());

final _levelTopicsProvider =
    FutureProvider.family<LanguageLevelWithTopics, (String, String)>(
        (ref, tuple) async {
  final cache = ref.watch(_cacheServiceProvider);
  final cacheKey = CacheKeys.levelTopics(tuple.$1, tuple.$2);

  // Cache'den dene (1 saat TTL)
  final cached = await cache.get<LanguageLevelWithTopics>(
    cacheKey,
    (json) => LanguageLevelWithTopics.fromJson(json as Map<String, dynamic>),
    ttl: const Duration(hours: 1),
  );
  if (cached != null) return cached;

  // API'den çek, cache'e yaz
  final apiService = ApiService();
  final result = await apiService.getLanguageLevelWithTopics(tuple.$1, tuple.$2);
  await cache.set(cacheKey, result.toJson());
  return result;
});

final _topicLessonsProvider =
    FutureProvider.family<GrammarTopicWithLessons, int>((ref, topicId) async {
  final cache = ref.watch(_cacheServiceProvider);
  final cacheKey = CacheKeys.topicLessons(topicId);

  final cached = await cache.get<GrammarTopicWithLessons>(
    cacheKey,
    (json) => GrammarTopicWithLessons.fromJson(json as Map<String, dynamic>),
    ttl: const Duration(minutes: 30),
  );
  if (cached != null) return cached;

  final apiService = ApiService();
  final result = await apiService.getGrammarTopicWithLessons(topicId);
  await cache.set(cacheKey, result.toJson());
  return result;
});
