import 'package:flutter/material.dart';
import '../utils/schedule_widgets.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
                    'Расписание на неделю',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ScheduleDayWidget(
                    day: 'Суббота',
                    subjects: [
                      '09:00 - 19:30\nРазработка кроссплатформенных мобильных приложений',
                    ],
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
