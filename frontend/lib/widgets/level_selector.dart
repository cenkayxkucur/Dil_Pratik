import 'package:flutter/material.dart';
import '../models/language.dart';

class LevelSelector extends StatelessWidget {
  final LanguageLevel? selectedLevel;
  final Function(LanguageLevel) onLevelSelected;

  const LevelSelector({
    super.key,
    this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: LanguageLevel.values.map((level) {
          final isSelected = selectedLevel == level;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(
                level.displayName.split(' - ')[0], // Show only "A1", "B2", etc.
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onLevelSelected(level);
                }
              },
              selectedColor: _getLevelColor(level).withOpacity(0.3),
              checkmarkColor: _getLevelColor(level),
              backgroundColor: _getLevelColor(level).withOpacity(0.1),
              side: BorderSide(
                color: _getLevelColor(level),
                width: isSelected ? 2 : 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getLevelColor(LanguageLevel level) {
    switch (level) {
      case LanguageLevel.A1:
        return Colors.green;
      case LanguageLevel.A2:
        return Colors.lightGreen;
      case LanguageLevel.B1:
        return Colors.orange;
      case LanguageLevel.B2:
        return Colors.deepOrange;
      case LanguageLevel.C1:
        return Colors.red;
      case LanguageLevel.C2:
        return Colors.purple;
    }
  }
}
