import 'package:flutter/material.dart';
import '../models/lesson.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(bool) onAnswered;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? _selectedAnswer;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...widget.question.options.map(
              (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedAnswer,
                onChanged: _isAnswered
                    ? null
                    : (value) {
                        setState(() => _selectedAnswer = value);
                      },
              ),
            ),
            const SizedBox(height: 16),
            if (_isAnswered)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(                  color: _selectedAnswer == widget.question.correctAnswer
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedAnswer == widget.question.correctAnswer
                          ? 'Doğru!'
                          : 'Yanlış. Doğru cevap: ${widget.question.correctAnswer}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _selectedAnswer == null
                      ? null
                      : () {
                          setState(() => _isAnswered = true);
                          widget.onAnswered(
                            _selectedAnswer == widget.question.correctAnswer,
                          );
                        },
                  child: const Text('Yanıtla'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
