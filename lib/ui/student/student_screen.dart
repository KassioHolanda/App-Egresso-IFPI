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
  final drawerController = GetIt.I.get<Utils>();

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
                  Text('Status matricula'),
                  Text('Curso'),
                  Text('Nome'),
                  Text('Matricula')
                ],
              ),
              title: Text('Filtrar'),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return DetailStudent();
          }));
        },
      ),
      backgroundColor: Colors.grey[200],
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Alunos encontrados'),
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                showFiltersStudent();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
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
                    child: Column(
                      children: [
                        Text('Filtros selecionados'),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            Usuario user =
                                Usuario.fromDocument(documentos[index]);
                            return StudentCard(user);
                          },
                          itemCount: documentos.length,
                        )
                      ],
                    ),
                  );
                }
                return Container();
            }
          },
        ),
      ),
    );
  }
}
