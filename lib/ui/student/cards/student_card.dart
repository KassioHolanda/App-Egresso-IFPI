import 'package:egresso_ifpi/controllers/student_controller.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:egresso_ifpi/ui/student/detail_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class StudentCard extends StatelessWidget {
  final studentController = StudentController(false);
  final Usuario user;

  StudentCard(this.user);

  @override
  Widget build(BuildContext context) {
    showConfirmRemove() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Deseja remover o usuário?'),
              actions: [
                FlatButton(onPressed: () {}, child: Text('Sim')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Não'))
              ],
            );
          });
    }

    return Container(
      child: FutureBuilder(
        future: studentController.getDataStudent(user.pessoaUid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
                ),
              );
            default:
              return Observer(
                builder: (_) {
                  return studentController.person.uid != null
                      ? Container(
                          // elevation: 0,
                          // shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          // color: studentController.isMatriculaInProgress()
                          //     ? Colors.green[200]
                          //     : Colors.red[200],
                          // width: 2),
                          //   borderRadius: BorderRadius.circular(4),
                          // ),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: ListTile(
                              // onLongPress: () {
                              //   showConfirmRemove();
                              // },
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return DetailStudent(
                                      studentC: studentController);
                                }));
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                    studentController.isMatriculaInProgress()
                                        ? Colors.green
                                        : Colors.red,
                                child: Text(
                                  '${studentController.person.nome[0]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              title: Text(
                                '${studentController.person.nome}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${studentController.person.email}'),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  studentController.isMatriculaInProgress()
                                      ? Container()
                                      : Text(
                                          'Esse aluno não possui matricula ativa.'),
                                  Text(
                                      '${studentController.matriculas.length} matricula(s) encontradas.')
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container();
                },
              );
          }
        },
      ),
    );
  }
}
