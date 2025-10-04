import 'package:flutter/material.dart';

class SubjectGradeWidget extends StatelessWidget {
  final String subject;
  final int grade;

  const SubjectGradeWidget({
    super.key,
    required this.subject,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    Color gradeColor = grade >= 4 ? Colors.green : Colors.orange;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(subject),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              grade.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: gradeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradesStatsWidget extends StatelessWidget {
  final double averageGrade;
  final int excellentCount;
  final int goodCount;
  final int satisfactoryCount;

  const GradesStatsWidget({
    super.key,
    required this.averageGrade,
    required this.excellentCount,
    required this.goodCount,
    required this.satisfactoryCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Средний балл:'),
                Text(
                  averageGrade.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Отличных оценок:'),
                Text(
                  excellentCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Хороших оценок:'),
                Text(
                  goodCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Удовлетворительных:'),
                Text(
                  satisfactoryCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
