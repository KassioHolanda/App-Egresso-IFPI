import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/ui/settings/manage_courses_screen.dart';
import 'package:egresso_ifpi/ui/settings/my_data_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ManageCoursesScreen();
                }));
              },
              title: Text('Cursos'),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return MyDataScreen();
                }));
              },
              title: Text('Meus dados'),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              title: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
