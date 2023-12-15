import 'package:flutter/material.dart';
import '../screens/news_screen.dart';

class NewsHeader extends StatelessWidget {
  final NewsItem news;

  NewsHeader({required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(news.imageUrl, height: 100, fit: BoxFit.cover),
        SizedBox(height: 8),
        Text(
          news.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 120, // Ajusta según sea necesario
          child: SingleChildScrollView(
            child: Text(
              news.content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
