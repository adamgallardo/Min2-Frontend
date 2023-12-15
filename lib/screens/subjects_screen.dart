import 'package:ea_proyecto_flutter/screens/subjects_edit.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';

class SubjectsScreen extends StatefulWidget {
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  late Future<List<NewItem>> futureAsignaturas;

  @override
  void initState() {
    futureAsignaturas = _getasignaturas();
    super.initState();
  }

  Future<List<NewItem>> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId = prefs.getString('id') ?? '';
    return await asignaturaApiService.GetAsignaturasById(storedId);
  }

  Future<void> _editAsignatures() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditSubjectsScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Asignaturas'),
      ),
      body: FutureBuilder(
        future: futureAsignaturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the data has been successfully fetched
            List<NewItem> newList = snapshot.data as List<NewItem>;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(newList[index].name),
                        // Customize the ListTile as needed
                      );
                    },
                  ),
                ),
                MyButton(
                  onTap: _editAsignatures,
                  text: 'Editar Asignatures',
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
