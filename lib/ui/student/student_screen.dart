import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/controllers/student_controller.dart';
import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/ui/student/cards/student_card.dart';
import 'package:egresso_ifpi/ui/student/detail_student_screen.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class StudentScreen extends StatelessWidget {
  final loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    showFiltersStudent() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                        hintText: 'Filtre os alunos por nome.'),
                  ),
                ],
              ),
              title: Text('Filtrar'),
              actions: [
                FlatButton(
                  onPressed: null,
                  child: Text('Filtrar'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
    }

    return Scaffold(
      floatingActionButton: loginController.userController.user.tipoUsuario ==
              'admin'
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return DetailStudent();
                }));
              },
            )
          : null,
      // backgroundColor: Colors.grey[100],
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Alunos encontrados'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showFiltersStudent();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuario')
                  .where('tipo_usuario', isEqualTo: 'aluno')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    final documentos = snapshot.data.docs;
                    if (documentos.length > 0) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            Usuario user =
                                Usuario.fromDocument(documentos[index]);
                            return StudentCard(user);
                          },
                          itemCount: documentos.length,
                        ),
                      );
                    }
                    return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
