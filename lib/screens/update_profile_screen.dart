import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../api/services/userService.dart';
import '../screens/user_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String storedName = '';
  String storedEmail = '';
  String storedRol = '';
  String storedPassword = '';
  String storedId = '';
  String storedImage = '';
  String token = '';

  File? _imageFile;
  Uint8List webImage = Uint8List(8);
  String? _imageUrl;

  Cloudinary? cloudinary;

  // api controller
  final UserApiService userApiService = UserApiService();

  // Controlador para el campo de contraseña
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable para rastrear si la contraseña es visible
  bool isNewPasswordVisible = false;
  bool isPasswordVisible = false;

  /* Uint8List? _image; */

  @override
  void initState() {
    super.initState();
    cloudinary = Cloudinary.signedConfig(
      apiKey: '248635653313453',
      apiSecret: 'mATgE6us-MJeNRGD29Y-dkR9tE0',
      cloudName: 'db2guqknt',
    );
    _loadUserData();
  }

  /* void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  } */

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var selected = File(pickedFile.path);
        setState(() {
          _imageFile = selected;
        });
        _uploadImage();
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
        _uploadImage();
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
          folder: 'profile',
        );
      } else if (kIsWeb) {
        // If the image is of type web
        response = await cloudinary!.upload(
          fileBytes: webImage,
          resourceType: CloudinaryResourceType.image,
          folder: 'profile',
        );
      } else {
        print('Algo no va');
        return;
      }

      setState(() {
        _imageUrl = response.secureUrl;
        print('devuelve la URL: $_imageUrl');
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('image', _imageUrl!);

      _updateUserImage();
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera los valores almacenados en SharedPreferences
    storedName = prefs.getString('name') ??
        ''; // Puedes establecer un valor predeterminado si es nulo
    storedRol = prefs.getString('rol') ?? '';
    storedEmail = prefs.getString('email') ?? '';
    storedPassword = prefs.getString('password') ?? '';
    storedId = prefs.getString('id') ?? '';
    storedImage = prefs.getString('image') ?? '';
    token = prefs.getString('token') ?? '';

    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  Future<void> _updateUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newImage = prefs.getString('image') ?? '';
    try {
      await userApiService.updateImage(
        userId: storedId,
        username: storedName,
        email: storedEmail,
        password: storedPassword,
        image: newImage,
        token: token,
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
  }

  Future<void> _updateUser() async {
    if (passwordController.text.isEmpty || newPasswordController.text.isEmpty) {
      // Muestra un mensaje de error si algún campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sisplau, completa tots els camps'),
        ),
      );
      return; // Sale de la función si algún campo está vacío
    }
    try {
      final responseData = await userApiService.updateUser(
        userId: storedId,
        username: storedName,
        email: storedEmail,
        password: passwordController.text,
        newPassword: newPasswordController.text,
        token: token,
      );

      final String password = responseData['password'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('password', password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserScreen(),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Editar perfil'),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _imageFile == null && storedImage == ''
                          ? const Image(
                              image: NetworkImage(
                                  'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                            )
                          : storedImage != ''
                              ? Image.network(
                                  storedImage,
                                  fit: BoxFit.fill,
                                )
                              : kIsWeb
                                  ? Image.memory(
                                      webImage,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      _imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(0, 125, 204,
                            1.0), // Puedes ajustar el color según tus necesidades
                      ),
                      child: IconButton(
                        onPressed: () => _pickImage(),
                        icon: const Icon(Icons.camera),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom usuari: $storedName',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      enabled: false, // No se puede editar
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail: $storedEmail',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      enabled: false, // No se puede editar
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contrasenya',
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Cambiar la visibilidad de la contraseña
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: !isNewPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contrasenya nova',
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Cambiar la visibilidad de la contraseña
                            setState(() {
                              isNewPasswordVisible = !isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 125, 204,
                              1.0), // Puedes ajustar el color según tus necesidades
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Edit Profile',
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
