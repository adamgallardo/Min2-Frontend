import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import '../widgets/text_widget.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});
  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final NewsApiService newsApiService = NewsApiService();
  TextEditingController titleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Cloudinary? cloudinary;
  File? _imageFile;
  Uint8List webImage = Uint8List(8);
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    cloudinary = Cloudinary.signedConfig(
      apiKey: '248635653313453',
      apiSecret: 'mATgE6us-MJeNRGD29Y-dkR9tE0',
      cloudName: 'db2guqknt',
    );
  }

  Future<void> createNews() async {
    if (titleController.text.isEmpty ||
        _imageUrl!.isEmpty ||
        contentController.text.isEmpty) {
      // Muestra un mensaje de error si algún campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sisplau, completa tots els camps'),
        ),
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      await newsApiService.createNews(
          titleController.text, _imageUrl!, contentController.text, token);
      // La noticia se creó correctamente, puedes mostrar un mensaje y luego navegar de regreso a NewsScreen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Noticia Creada'),
          content: Text('La notícia sha creat correctament.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsScreen(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Maneja el error si la creación de la noticia no fue exitosa
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Hi ha hagut un error al crear la notícia. Sisplau, intenteu de nou.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var selected = File(pickedFile.path);
        setState(() {
          _imageFile = selected;
        });
      } else {
        print('No ha triat imatge');
        return;
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var f = await pickedFile.readAsBytes();
        setState(() {
          webImage = f;
          _imageFile = File('a');
        });
      } else {
        print('No ha triat imatge');
        return;
      }
    } else {
      print('Algo no va');
      return;
    }
  }

  Future<void> _uploadImage() async {
    try {
      CloudinaryResponse response;

      if (_imageFile != null && !kIsWeb) {
        // If the image is of type File (non-web)
        response = await cloudinary!.upload(
          file: _imageFile!.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'news',
        );
      } else if (kIsWeb) {
        // If the image is of type web
        response = await cloudinary!.upload(
          fileBytes: webImage,
          resourceType: CloudinaryResourceType.image,
          folder: 'news',
        );
      } else {
        print('Algo no va');
        return;
      }

      setState(() {
        _imageUrl = response.secureUrl;
        print('devuelve la URL: $_imageUrl');
      });
      createNews();
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
    }
  }

  /*Future<void> _updateNewsImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newImage = prefs.getString('image') ?? '';
    try {
      await newsApiService.updateImage(
        userId: storedId,
        username: storedName,
        email: storedEmail,
        password: storedPassword,
        image: newImage,
      );
    } catch (e) {
      // Maneja errores de conexión o cualquier otra excepción
      // ignore: avoid_print
      print('Error image: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }*/
  void _clearForm() {
    titleController.clear();
    contentController.clear();
    setState(() {
      _imageFile = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crear Noticia'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _imageFile == null
                          ? dottedBorder(color: Colors.blue)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kIsWeb
                                  ? Image.memory(webImage, fit: BoxFit.fill)
                                  : Image.file(_imageFile!, fit: BoxFit.fill),
                            )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: _clearForm, child: Text('Clear form')),
                  ],
                ),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Títul'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Contingut'),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Crear Noticia'),
              ),
            ],
          ),
        ));
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    );
  }
}
