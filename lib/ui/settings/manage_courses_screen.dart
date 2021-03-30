import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/courses_controller.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ManageCoursesScreen extends StatelessWidget {
  final courseController = CoursesController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    showMessage(String message) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        duration: new Duration(seconds: 3),
      ));
    }

    List<DropdownMenuItem<String>> typeLevel() {
      List<DropdownMenuItem<String>> itens = List();
      itens.add(DropdownMenuItem(
        value: 'bacharel',
        child: Text(
          'Bacharel',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'licenciatura',
        child: Text(
          'Licenciatura',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'medio_integrado',
        child: Text(
          'Médio Integrado',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'tecnico',
        child: Text(
          'Técnico',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'tecnologo',
        child: Text(
          'Tecnologo',
          style: TextStyle(color: Colors.black),
        ),
      ));

      return itens;
    }

    confirmDelete({CursoModel course}) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Tem certeza?'),
              actions: [
                Observer(
                  builder: (_) {
                    return FlatButton(
                        onPressed: courseController.utilsController.loading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text(
                          'Não',
                          style: TextStyle(color: Colors.red),
                        ));
                  },
                ),
                Observer(
                  builder: (_) {
                    return FlatButton(
                        onPressed: courseController.utilsController.loading
                            ? null
                            : () async {
                                courseController.setCourse(course);
                                await courseController
                                    .deleteCourse(showMessage);
                                Navigator.pop(context);
                              },
                        child: Text(
                          'Sim',
                        ));
                  },
                ),
              ],
            );
          });
    }

    addCourse({CursoModel course}) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Adicionar'),
              actions: [
                Observer(
                  builder: (_) {
                    return FlatButton(
                        onPressed: courseController.utilsController.loading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ));
                  },
                ),
                Observer(
                  builder: (_) {
                    return FlatButton(
                        onPressed: courseController.utilsController.loading
                            ? null
                            : () async {
                                if (formKey.currentState.validate()) {
                                  await courseController
                                      .saveCourse(showMessage);
                                  Navigator.pop(context);
                                }
                              },
                        child: Text(
                          'Salvar',
                        ));
                  },
                ),
              ],
              content: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: courseController.course.setDescription,
                      maxLines: 3,
                      controller: TextEditingController(
                          text: course != null ? course.description : ''),
                      validator: (text) =>
                          text.isEmpty ? 'Campo obrigatório' : null,
                      decoration: InputDecoration(labelText: 'Descrição'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                        icon: Icon(
                          Icons.arrow_drop_down,
                        ),
                        elevation: 2,
                        validator: (text) {
                          if (text == null) {
                            return 'Campo obrigatório';
                          }
                        },
                        value: course != null
                            ? course.level
                            : courseController.course.level,
                        isExpanded: true,
                        items: typeLevel(),
                        decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.credit_card),
                            // border: OutlineInputBorder(),
                            labelText: 'Nível'),
                        onChanged: courseController.course.setLevel),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            );
          });
    }

    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          addCourse();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Gerenciar cursos'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        child: StreamBuilder(
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
                final documents = snapshot.data.docs;
                if (documents.length > 0) {
                  return ListView.builder(
                    itemBuilder: (_, index) {
                      final course = CursoModel.fromDocument(documents[index]);
                      return ListTile(
                        onTap: () {
                          // courseController.setCourse(course);
                          addCourse(course: course);
                        },
                        leading: Text('${index + 1}'),
                        title: Text(
                          '${course.description}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            '${course.level.toUpperCase().replaceAll('_', ' ')}'),
                        trailing: IconButton(
                          onPressed: () {
                            confirmDelete(course: course);
                          },
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
          stream: FirebaseFirestore.instance
              .collection('curso')
              .orderBy('descricao')
              .snapshots(),
        ),
      ),
    );
  }
}
