import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/manage_user_controller.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/domain/model/curso_funcionario.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AddCoursesUser extends StatelessWidget {
  final ManageUserController manageUserController;
  final utilsController = GetIt.I.get<Utils>();

  AddCoursesUser(this.manageUserController);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> tipoCargo() {
      List<DropdownMenuItem<String>> itens = List();
      itens.add(DropdownMenuItem(
        value: 'coordenador',
        child: Text(
          'Coordenador',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'professor',
        child: Text(
          'Professor',
          style: TextStyle(color: Colors.black),
        ),
      ));

      return itens;
    }

    List<DropdownMenuItem<CursoModel>> cursos() {
      List<DropdownMenuItem<CursoModel>> itens = List();

      for (CursoModel c in utilsController.coursesFinded) {
        itens.add(DropdownMenuItem(
          value: c,
          child: Text(
            c.description,
            style: TextStyle(color: Colors.black),
          ),
        ));
      }
      return itens;
    }

    showSelectOfficeAnCourse() {
      showDialog(
          context: context,
          builder: (_) {
            CursoFuncionarioModel cursoFuncionarioModel =
                CursoFuncionarioModel();

            return AlertDialog(
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    )),
                FlatButton(
                    onPressed: () {
                      manageUserController
                          .addCursoAoFuncionario(cursoFuncionarioModel);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Adicionar',
                    )),
              ],
              title: Text('Adicionar cargo ao usuário'),
              content: Column(
                children: [
                  DropdownButtonFormField<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                      ),
                      elevation: 2,
                      validator: (text) {
                        if (text == null) {
                          return 'Cargo obrigatório';
                        }
                      },
                      value: cursoFuncionarioModel.cargo,
                      isExpanded: true,
                      items: tipoCargo(),
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(),
                          labelText: 'Cargo'),
                      onChanged: cursoFuncionarioModel.setCargo),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: utilsController.returnAllCourses(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                              // child: Container(
                              //   child: CircularProgressIndicator(),
                              // ),
                              );
                        default:
                          return DropdownButtonFormField<CursoModel>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              elevation: 2,
                              validator: (text) {
                                if (text == null) {
                                  return 'Matricula obrigatória';
                                }
                              },
                              value: cursoFuncionarioModel.cursoModel,
                              isExpanded: true,
                              items: cursos(),
                              decoration: InputDecoration(
                                  // prefixIcon: Icon(Icons.credit_card),
                                  border: OutlineInputBorder(),
                                  labelText: 'Matricula'),
                              onChanged: cursoFuncionarioModel.setCurso);
                      }
                    },
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showSelectOfficeAnCourse();
              },
            )
          ],
          title: Text('Adicionar cursos ao usuário'),
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (_) {
                  return manageUserController.coursesEmployee.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return Container(
                              child: ListTile(
                                leading: Text('${index + 1}'),
                                title: Text(
                                    '${manageUserController.coursesEmployee[index].cursoModel.description}'),
                                subtitle: Text(
                                    '${manageUserController.coursesEmployee[index].cargo}'),
                              ),
                            );
                          },
                          itemCount:
                              manageUserController.coursesEmployee.length,
                        )
                      : Container(
                          child: Center(
                            child: Text('Nenhum curso adicionado.'),
                          ),
                        );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(6),
                color: Colors.red[400],
              ),
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )));
  }
}
