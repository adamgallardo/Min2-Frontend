import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/navigation_drawer.dart';
import '../main.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  String? adminMode;
  String? darkMode;
  String? rol = '';

  @override
  void initState() {
    super.initState();
    _loadConfigurationData();
  }

  Future<void> _loadConfigurationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminMode = prefs.getString('adminMode');
    darkMode = prefs.getString('darkMode') ?? '0';
    rol = prefs.getString('rol');
    setState(() {});
  }

  Future<void> _toggleAdminMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('adminMode', adminMode == '1' ? '0' : '1');
    setState(() {
      adminMode = prefs.getString('adminMode') ?? '0';
    });
  }

  Future<void> _toggleDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('darkMode', darkMode == '1' ? '0' : '1');
    setState(() {
      darkMode = prefs.getString('darkMode') ?? '0';
    });
     _updateTheme();
  }
  void _updateTheme() {
    bool isDarkModeEnabled = darkMode == '1';
    if (isDarkModeEnabled) {
      // Si darkMode está activado, establecer el tema oscuro
      MyApp.setTheme(context, ThemeData.dark());
    } else {
      // Si darkMode está desactivado, establecer el tema claro
      MyApp.setTheme(context, ThemeData.light());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Configuració'),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(rol == "admin")
            ListTile(
              title: Text('Mode Admin'),
              trailing: CupertinoSwitch(
                value: adminMode == '1',
                onChanged: (bool value){
                  _toggleAdminMode();
                },
              ),
            ),
            SizedBox(height: 16.0),
           ListTile(
              title: Text('Mode Fosc'),
              trailing: CupertinoSwitch(
                value: darkMode == '1',
                onChanged: (bool value){
                  _toggleDarkMode();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}