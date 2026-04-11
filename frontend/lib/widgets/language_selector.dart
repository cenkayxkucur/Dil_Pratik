import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageSelector extends StatelessWidget {
  final Language? selectedLanguage;
  final Function(Language) onLanguageSelected;

  const LanguageSelector({
    super.key,
    this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: supportedLanguages.map((language) {
          final isSelected = selectedLanguage?.code == language.code;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(language.flag),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      language.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onLanguageSelected(language);
                }
              },
              selectedColor: Colors.blue.withOpacity(0.2),
              checkmarkColor: Colors.blue,
            ),
          );
        }).toList(),
      ),
    );
  }
}
