import 'package:flutter/material.dart';
import '../utils/grades_widgets.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Успеваемость',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SubjectGradeWidget(subject: 'Разработка кроссплатформенных мобильных приложений', grade: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GradesStatsWidget(
            averageGrade: 5,
            excellentCount: 1,
            goodCount: 0,
            satisfactoryCount: 0,
          ),
        ],
      ),
    );
  }

}
