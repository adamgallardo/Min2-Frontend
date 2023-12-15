import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/news_update_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:ea_proyecto_flutter/widgets/news_header.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsItem news;
  NewsDetailScreen({required this.news});
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsApiService newsApiService = NewsApiService();
  TextEditingController commentController = TextEditingController();
  double userRating = 0.0;
  String? adminMode = '';
  String? username = '';
  String token = '';
  double ratingsSum = 0.0;
  double averageRating = 0.0;
  @override
  void initState() {
    _loadNewsData();
    super.initState();
  }

  Future<void> _loadNewsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminMode = prefs.getString('adminMode');
    username = prefs.getString('name');
    token = prefs.getString('token') ?? '';
    ratingsSum = widget.news.ratings.reduce((sum, rating) => sum + rating);
    averageRating = ratingsSum / widget.news.ratings.length;
    setState(() {});
  }

  Future<void> _deleteNewsData() async {
    String id = widget.news.id;
    try {
      await newsApiService.deleteNews(id, token);
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

  Future<void> _addCommentAndRating() async {
    String text = commentController.text;
    double rating = userRating;
    String id = widget.news.id;
    await newsApiService.addCommentAndRating(id, text, rating, username, token);
    widget.news.comments
        .add(Comment(username: username, text: text, rating: rating));
    widget.news.ratings.add(rating);

    // Recalcula el promedio de calificaciones
    ratingsSum = widget.news.ratings.reduce((sum, rating) => sum + rating);
    averageRating = ratingsSum / widget.news.ratings.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comentario añadido exitosamente'),
        duration: Duration(seconds: 2),
      ),
    );
    // Limpia el controlador de comentarios
    commentController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Notícies'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (adminMode == '1')
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Borrar Notícia",
                            style: TextStyle(fontSize: 20),
                          ),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                                "¿Estàs segur que vols borrar la notícia?"),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await _deleteNewsData();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen()),
                                    (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                side: BorderSide.none,
                              ),
                              child: const Text("Sí"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              },
                              child: const Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mode),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewsUpdateScreen(news: widget.news)),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsHeader(news: widget.news),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: commentController,
                    decoration:
                        InputDecoration(labelText: 'Afegeix un comentari'),
                  ),
                  RatingBar.builder(
                    initialRating: userRating,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        userRating = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addCommentAndRating();
                    },
                    child: Text('Afegeix el comentari'),
                  ),
                ],
              ),
            ),
            if (widget.news.comments.isNotEmpty) ...[
              SizedBox(height: 6),
              Text('Comentaris:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Container(
                height: 150, // Ajusta según sea necesario
                child: ListView.builder(
                  itemCount: widget.news.comments.length,
                  itemBuilder: (context, index) {
                    Comment comment = widget.news.comments[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${comment.username}: ${comment.text}'),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors
                    .blue[100], // Ajusta el color según tu paleta de colores
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Valoració mitjana: $averageRating',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
