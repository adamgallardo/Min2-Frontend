//import 'package:ea_proyecto_flutter/screens/news_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/news_screen.dart';

class NewsUpdateScreen extends StatefulWidget {
  final NewsItem news;
  NewsUpdateScreen({required this.news, super.key});
  _NewsUpdateScreenState createState() => _NewsUpdateScreenState();
}

class _NewsUpdateScreenState extends State<NewsUpdateScreen> {
  // api controller
  final NewsApiService newsApiService = NewsApiService();

  // Controlador para el campo de contraseña
  final TextEditingController newTitleController = TextEditingController();
  final TextEditingController newImageUrlController = TextEditingController();
  final TextEditingController newContentController = TextEditingController();
  String title = '';
  String imageUrl = '';
  String content = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateNews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (newTitleController.text.isEmpty) {
      title = widget.news.title;
    } else {
      title = newTitleController.text;
    }
    if (newImageUrlController.text.isEmpty) {
      imageUrl = widget.news.imageUrl;
    } else {
      imageUrl = newImageUrlController.text;
    }
    if (newContentController.text.isEmpty) {
      content = widget.news.content;
    } else {
      content = newContentController.text;
    }
    try {
      await newsApiService.updateNews(
        newsId: widget.news.id,
        newTitle: title,
        title: widget.news.title,
        imageUrl: imageUrl,
        content: content,
        token: token,
      );
      widget.news.title = title;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(),
        ),
      );
    } catch (e) {
      // Maneja errores de conexión o cualquier otra excepción
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.news.title;
    String imageUrl = widget.news.imageUrl;
    String content = widget.news.content;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_left),
        ),
        title: const Text('Editar notícia'),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: newTitleController,
                      decoration: InputDecoration(
                        labelText: 'Títul: $title',
                        prefixIcon: const Icon(Icons.title),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: newImageUrlController,
                      decoration: InputDecoration(
                        labelText: 'imageUrl: $imageUrl',
                        prefixIcon: const Icon(Icons.image),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextFormField(
                      controller: newContentController,
                      decoration: InputDecoration(
                        labelText: 'Contenido: $content',
                        prefixIcon: const Icon(Icons.content_copy_outlined),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateNews,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 125, 204,
                              1.0), // Puedes ajustar el color según tus necesidades
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Editar Notícia',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
