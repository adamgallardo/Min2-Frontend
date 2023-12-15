//import 'package:ea_proyecto_flutter/screens/news_details_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:ea_proyecto_flutter/screens/news_create_screen.dart';
import '../widgets/news_item_card.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService newsApiService = NewsApiService();
  List<NewsItem> newsList = [];
  String? adminMode = '';
  @override
  void initState() {
    super.initState();
    _loadNewsData();
  }

  Future<void> _loadNewsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminMode = prefs.getString('adminMode');
    try {
      final List<dynamic> response = await newsApiService.readNews();
      // Mapea la respuesta a objetos NewsItem
      newsList = response.map((data) => NewsItem.fromJson(data)).toList();
      print(newsList);
      // Notifica al framework que el estado ha cambiado
      setState(() {});
    } catch (e) {
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al conectar amb el servidor'),
        ),
      );
    }
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Notícies'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        actions: [
          if (adminMode == '1')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Navega a la pantalla de creación de noticias cuando se hace clic en el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navega a la pantalla de detalles cuando se hace clic en una noticia
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news: newsList[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(newsList[index].imageUrl,
                      height: 200, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newsList[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Notícies'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        actions: [
          if (adminMode == '1')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildNewsList(),
    );
  }

  Widget _buildNewsList() {
      return ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return NewsItemCard(news: newsList[index]);
        },
      );
    }
  }



class NewsItem {
  final String id;
  String title;
  final String imageUrl;
  final String content;
  List<Comment> comments;
  List<dynamic> ratings;

  NewsItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.comments,
      required this.ratings});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        ratings: json['ratings'],
        comments: (json['comments'] as List<dynamic>)
            .map((commentData) => Comment.fromJson(commentData))
            .toList());
  }
}

class Comment {
  final String? username;
  final String? text;
  final double? rating;

  Comment({
    required this.username,
    required this.text,
    required this.rating,
  });

  // Add a factory method to create a Comment from JSON data
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'],
      text: json['text'],
      rating: json['rating'].toDouble(),
    );
  }
}
