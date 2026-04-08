import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/language_provider.dart';
import '../providers/vocabulary_provider.dart';
import '../services/vocabulary_service.dart';
import '../services/user_session_service.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final language = selectedLanguage?.code ?? 'english';

    final wordsAsync = ref.watch(savedWordsProvider(language));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedLanguage?.flag ?? ''} Kelime Defterim',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Arama
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kelime ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          const SizedBox(height: 8),
          // Liste
          Expanded(
            child: wordsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Kelimeler yüklenemedi')),
              data: (words) {
                final filtered = _search.isEmpty
                    ? words
                    : words
                        .where((w) =>
                            w.word.contains(_search) ||
                            (w.translation?.toLowerCase().contains(_search) ??
                                false))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.menu_book_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          _search.isEmpty
                              ? 'Henüz kelime kaydetmedin'
                              : '"$_search" bulunamadı',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        if (_search.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Pratik yaparken \u{1F4D6} ile kelime ekleyebilirsin',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final word = filtered[i];
                    return _WordTile(
                      word: word,
                      onDelete: () async {
                        final userId = UserSessionService.getCurrentUserId();
                        final service = ref.read(vocabularyServiceProvider);
                        final ok = await service.deleteWord(word.id, userId);
                        if (ok) {
                          ref.invalidate(savedWordsProvider(language));
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Kelime ekle butonu
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Kelime Ekle'),
        onPressed: () => _showAddWordDialog(context, language),
      ),
    );
  }

  Future<void> _showAddWordDialog(BuildContext context, String language) async {
    final wordCtrl = TextEditingController();
    final translationCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kelime Kaydet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordCtrl,
              decoration: const InputDecoration(
                labelText: 'Kelime',
                hintText: 'Kaydetmek istediğin kelime',
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: translationCtrl,
              decoration: const InputDecoration(
                labelText: 'Anlam / Not (isteğe bağlı)',
                hintText: 'Türkçesi veya açıklama',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () async {
              final word = wordCtrl.text.trim();
              if (word.isEmpty) return;
              Navigator.of(ctx).pop();
              final service = ref.read(vocabularyServiceProvider);
              final userId = UserSessionService.getCurrentUserId();
              final ok = await service.saveWord(
                userId: userId,
                language: language,
                word: word,
                translation: translationCtrl.text.trim().isEmpty
                    ? null
                    : translationCtrl.text.trim(),
              );
              if (ok && mounted) {
                ref.invalidate(savedWordsProvider(language));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"$word" kaydedildi')),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    wordCtrl.dispose();
    translationCtrl.dispose();
  }
}

class _WordTile extends StatelessWidget {
  final SavedWord word;
  final VoidCallback onDelete;

  const _WordTile({required this.word, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.teal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.translate, color: Colors.teal, size: 22),
      ),
      title: Text(
        word.word,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: word.translation != null
          ? Text(
              word.translation!,
              style: TextStyle(color: Colors.grey[600]),
            )
          : (word.context != null
              ? Text(
                  '"${word.context}"',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        tooltip: 'Sil',
        onPressed: onDelete,
      ),
    );
  }
}
