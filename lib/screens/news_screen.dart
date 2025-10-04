import 'package:flutter/material.dart';
import '../utils/news_widgets.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

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
                    'Новости',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  NewsItemWidget(
                    title: 'На месте «Большой глины» у ГЭС-2 устаналивают какую-то лопатку',
                    date: '03 октября 2025',
                    preview: 'Финансист утверждает, что цены на пиво в магазинах поднимутся на 8-12%. Причины: повышение акциза, рост расходов на производство.',
                    icon: Icons.science,
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
