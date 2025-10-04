import 'package:flutter/material.dart';

class ScheduleDayWidget extends StatelessWidget {
  final String day;
  final List<String> subjects;

  const ScheduleDayWidget({
    super.key,
    required this.day,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...subjects.map((subject) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(subject),
          ),
        )),
      ],
    );
  }
}
