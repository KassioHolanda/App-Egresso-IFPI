import 'package:egresso_ifpi/controllers/drawer_controller.dart';
import 'package:egresso_ifpi/ui/student/student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class DrawerConfig extends StatelessWidget {
  final drawerController = GetIt.I.get<DrawerPageController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Observer(
        builder: (_) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Nome usuário'),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Perfil'),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: drawerController.numPage == 0
                      ? Colors.white
                      : Colors.grey,
                ),
                selectedTileColor: Colors.green[300],
                selected: drawerController.numPage == 0,
                title: Text(
                  'Pagina inicial',
                  style: TextStyle(
                      color: drawerController.numPage == 0
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  drawerController.setNumPage(0);
                },
              ),
              ListTile(
                selectedTileColor: Colors.green[300],
                selected: drawerController.numPage == 1,
                leading: Icon(
                  Icons.group,
                  color: drawerController.numPage == 1
                      ? Colors.white
                      : Colors.grey,
                ),
                title: Text(
                  'Alunos',
                  style: TextStyle(
                      color: drawerController.numPage == 1
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  drawerController.setNumPage(1);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return StudentScreen();
                  }));
                },
              ),
              ListTile(
                selectedTileColor: Colors.green[300],
                selected: drawerController.numPage == 2,
                leading: Icon(
                  Icons.supervised_user_circle_rounded,
                  color: drawerController.numPage == 2
                      ? Colors.white
                      : Colors.grey,
                ),
                title: Text(
                  'Usuários',
                  style: TextStyle(
                      color: drawerController.numPage == 2
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  drawerController.setNumPage(2);
                },
              ),
              ListTile(
                selectedTileColor: Colors.green[300],
                selected: drawerController.numPage == 3,
                title: Text(
                  'Configurações',
                  style: TextStyle(
                      color: drawerController.numPage == 3
                          ? Colors.white
                          : Colors.black),
                ),
                onTap: () {
                  drawerController.setNumPage(3);
                },
                leading: Icon(
                  Icons.settings,
                  color: drawerController.numPage == 3
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: Text(
                  'Sair',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
