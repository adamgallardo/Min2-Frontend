import 'package:ea_proyecto_flutter/screens/subjects_screen.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:flutter/material.dart';
//import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
//import '../api/models/user.dart';

class EditSubjectsScreen extends StatefulWidget {
  @override
  _EditSubjectsScreenState createState() => _EditSubjectsScreenState();
}

class _EditSubjectsScreenState extends State<EditSubjectsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  final UserApiService userApiService = UserApiService();
  late Future<List<NewItem>> futureAsignaturas;
  late List<NewItem> newList = [];
  late List<bool> isCheckedList = [];
  late bool firstime = true;

  @override
  void initState() {
    futureAsignaturas = _getallasignaturas();
    super.initState();
  }

  Future<List<NewItem>> _getallasignaturas() async {
    return await asignaturaApiService.GetAllAsignaturas();
  }

  Future<void> _done() async {
    int i = 0;
    List<String> asignaturas = [];
    while (i < newList.length) {
      if (isCheckedList[i] == true) {
        asignaturas.add(newList[i].id);
      }
      i++;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await userApiService.updateSubjects(
        userId: prefs.getString('id') ?? '',
        username: prefs.getString('name') ?? '',
        email: prefs.getString('email') ?? '',
        password: prefs.getString('password') ?? '',
        token: prefs.getString('token') ?? '',
        asignatura: asignaturas);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubjectsScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Assignatures'),
      ),
      body: FutureBuilder<List<NewItem>>(
        future: futureAsignaturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // If the data has been successfully fetched
            if (firstime == true) {
              newList = snapshot.data as List<NewItem>;
              isCheckedList = List.generate(newList.length, (index) => false);
              firstime = false;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(newList[index].name),
                        value: isCheckedList[index],
                        onChanged: (value) {
                          setState(() {
                            isCheckedList[index] = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
                MyButton(
                  onTap: _done,
                  text: 'Editar',
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
