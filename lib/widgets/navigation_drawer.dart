import 'package:ea_proyecto_flutter/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/subjects_screen.dart';
import 'package:ea_proyecto_flutter/screens/activities_screen.dart';
import 'package:ea_proyecto_flutter/screens/group_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBar> {
  String storedName = '';
  String storedEmail = '';
  //String storedRol = '';
  //String adminMode = '';

  @override
  void initState() {
    super.initState();
    _loadNavData();
  }

  Future<void> _loadNavData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Recupera los valores almacenados en SharedPreferences
    storedName = prefs.getString('name') ??
        ''; // Puedes establecer un valor predeterminado si es nulo
    storedEmail = prefs.getString('email') ?? '';
    //storedRol = prefs.getString('rol') ?? '';
    //adminMode = prefs.getString('adminMode') ?? '';
    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //String username = widget.username;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$storedName'),
            accountEmail: Text('$storedEmail'),
            /*currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('images/paine.png')),
            ),*/
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 125, 204, 1.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('Notícies'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Assignatures'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.chat),
              title: Text('Xat'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Activitats'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              ),
            ),
          ),
          /*
          if (storedRol == 'admin')
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Modo admin'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('adminMode', adminMode == '1' ? '0' : '1');
                    // Actualiza el estado con el nuevo valor
                    setState(() {
                      adminMode = prefs.getString('adminMode') ?? '0';
                    });
                  }),
            ),*/
        ],
      ),
    );
  }
}
