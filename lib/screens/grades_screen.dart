import 'package:flutter/material.dart';
import '../utils/listview_separated_widget.dart';

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
                  ListViewSeparatedWidget(
                    title: 'Оценки',
                    hintText: 'Добавить оценку',
                    emptyMessage: 'Добавьте оценки',
                    icon: Icons.grade,
                    color: Colors.orange,
                    showEditButton: true,
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
