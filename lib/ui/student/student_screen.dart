import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/ui/student/detail_student_screen.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class StudentScreen extends StatelessWidget {
  final drawerController = GetIt.I.get<Utils>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Alunos encontrados'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('alunos').get(),
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
                      itemBuilder: (_, index) {
                        StudentModel student =
                            StudentModel.fromDocument(documentos[index]);
                        return Card(
                            child: ExpansionTile(
                          tilePadding: EdgeInsets.only(right: 10),
                          expandedAlignment: Alignment.topLeft,
                          childrenPadding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          children: [
                            TextFormField(
                              enabled: false,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                labelText: 'Status matricula:',
                                border: InputBorder.none,
                              ),
                              controller: TextEditingController(
                                  text:
                                      ''),
                            ),
                            // TextFormField(
                            //   enabled: false,
                            //   decoration: InputDecoration(
                            //     labelText: 'Data nascimento:',
                            //   ),
                            //   controller: TextEditingController(
                            //       text:
                            //           '${utils.returnDateDefault(student.dataNascimento)}'),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return DetailStudent(student);
                                    }));
                                  },
                                  child: Text(
                                    'Detalhar',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                          title: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text(''),
                          ),
                        ));
                      },
                      itemCount: documentos.length,
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
