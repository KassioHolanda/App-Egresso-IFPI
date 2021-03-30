import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:flutter/material.dart';

class ManageCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar cursos'),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Container(
                    child: RefreshProgressIndicator(),
                  ),
                );
              default:
                final documents = snapshot.data.docs;
                if (documents.length > 0) {
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      final course = CursoModel.fromDocument(documents[index]);
                      return ListTile(
                        title: Text(
                          '${course.description}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            '${course.level.toUpperCase().replaceAll('_', ' ')}'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    itemCount: documents.length,
                  );
                }
                return Container();
            }
          },
          future: FirebaseFirestore.instance
              .collection('curso')
              .orderBy('descricao')
              .get(),
        ),
      ),
    );
  }
}
