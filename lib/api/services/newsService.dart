import 'dart:convert';
import 'package:http/http.dart' as http;

//import '../models/news.dart'; // Encara no està implementat el model

class NewsApiService {
  static const String _baseUrl = 'http://localhost:9191/news';
  //static const String _baseUrl = 'http://192.168.1.140:9191/news';

  Future<void> createNews(
      String title, String imageUrl, String content, String token) async {
    try {
      var data = {
        'title': title,
        'imageUrl': imageUrl,
        'content': content,
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.post(Uri.parse(_baseUrl),
          headers: headerContentType, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<List<dynamic>> readNews() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<String> deleteNews(String id, String token) async {
    try {
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      String endpoint = '/$id';
      final response = await http.delete(
        Uri.parse(_baseUrl + endpoint),
        headers: headerContentType,
      );

      if (response.statusCode == 200) {
        return '1';
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<Map<String, dynamic>> updateNews({
    required String newsId,
    required String newTitle,
    required String title,
    required String imageUrl,
    required String content,
    required String token,
  }) async {
    try {
      var data = {
        'newTitle': newTitle,
        'title': title,
        'imageUrl': imageUrl,
        'content': content,
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.put(Uri.parse('$_baseUrl/$newsId'),
          headers: headerContentType, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar la notícia');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<void> addCommentAndRating(String newsId, String text, double rating,
      String? username, String token) async {
    try {
      var data = {
        'username': username,
        'text': text,
        'rating': rating,
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.post(Uri.parse('$_baseUrl/$newsId'),
          headers: headerContentType, body: jsonEncode(data));

      if (response.statusCode == 200) {
        // Comment and rating added successfully
      } else {
        // Handle the error case
        print('Error adding comment and rating: ${response.body}');
      }
    } catch (e) {
      // Handle any network or other errors
      print('Error: $e');
    }
  }
}
