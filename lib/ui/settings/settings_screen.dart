import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/ui/settings/manage_courses_screen.dart';
import 'package:egresso_ifpi/ui/settings/my_data_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final loginController = LoginController();
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
            loginController.userController.user.tipoUsuario != 'aluno'
                ? ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ManageCoursesScreen();
                      }));
                    },
                    title: Text('Cursos'),
                    trailing: Icon(Icons.chevron_right),
                  )
                : Container(),
            loginController.userController.user.tipoUsuario != 'aluno'
                ? Divider()
                : Container(),
            loginController.userController.user.tipoUsuario != 'aluno'
                ? ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyDataScreen();
                      }));
                    },
                    title: Text('Meus dados'),
                    trailing: Icon(Icons.chevron_right),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
