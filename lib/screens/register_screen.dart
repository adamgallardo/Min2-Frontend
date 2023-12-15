import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import '../screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // api controller
    final UserApiService userApiService = UserApiService();

    // text editing controllers
    final usernameTextController = TextEditingController();
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    final confirmPasswordTextController = TextEditingController();

    Future<void> _registerUser() async {
      if (usernameTextController.text.isEmpty ||
          emailTextController.text.isEmpty ||
          passwordTextController.text.isEmpty ||
          confirmPasswordTextController.text.isEmpty) {
        // Muestra un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sisplau, completa tots els camps'),
          ),
        );
        return; // Sale de la función si algún campo está vacío
      } else {
        if (passwordTextController.text != confirmPasswordTextController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Les contrasenyes no coincideixen'),
            ),
          );
          return;
        }
        try {
          userApiService.registerUser(
            username: usernameTextController.text,
            email: emailTextController.text,
            password: passwordTextController.text,
          );

          // Si la solicitud fue exitosa (código 200)
          // Registro exitoso, redirige a la pantalla de inicio de sesión
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } catch (e) {
          // Maneja errores de conexión o cualquier otra excepción
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(e.toString()),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.app_registration_outlined,
                  color: Color.fromRGBO(0, 125, 204, 1.0),
                  size: 100,
                ),

                const SizedBox(height: 35),

                //welcome back message
                Text(
                  "Completa el següent formulari i disfruta de totes les funcions que tenim preparades per a tu.",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 30),

                //username textfield
                MyTextField(
                    controller: usernameTextController,
                    hintText: 'Nom de usuari',
                    obscureText: false),

                const SizedBox(height: 25),

                //email textfield
                MyTextField(
                    controller: emailTextController,
                    hintText: 'E-mail',
                    obscureText: false),

                const SizedBox(height: 25),

                //password textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Contrasenya',
                    obscureText: true),

                const SizedBox(height: 25),

                //confirm password textfield
                MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirmar contrasenya',
                    obscureText: true),

                const SizedBox(height: 25),

                //Sign up button
                MyButton(
                  onTap: _registerUser,
                  text: 'CREAR COMPTE',
                ),

                const SizedBox(height: 20),

                //go to login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ja tens compte?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      child: Text(
                        "Inicia sessió",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
