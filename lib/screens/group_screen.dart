import 'package:flutter/material.dart';
import './chat_screen.dart';

class GroupsScreen extends StatelessWidget {
  final List<String> groups = [
    'Grup 1',
    'Grup 2',
    'Grup 3'
  ]; // Puedes cargar los grupos desde tu servidor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        title: Text('Grups'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(groupName: groups[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
