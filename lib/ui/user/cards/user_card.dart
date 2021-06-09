import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/manage_user_controller.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:egresso_ifpi/ui/settings/manage_courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class UserCard extends StatelessWidget {
  final Usuario usuario;
  final manageUserController = ManageUserController();

  UserCard(this.usuario);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              height: 1,
              child: LinearProgressIndicator(),
            );
          default:
            return Card(
              child: ExpansionTile(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: 'Email',
                          border: InputBorder.none),
                      controller: TextEditingController(
                        text: '${manageUserController.pessoa.email}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      readOnly: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_pin_rounded),
                          labelText: 'CPF',
                          border: InputBorder.none),
                      controller: MaskedTextController(
                          text: '${manageUserController.pessoa.cpf}',
                          mask: '000.000.000-00'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('cursoFuncionario')
                          .where('funcionario_uid',
                              isEqualTo: manageUserController.funcionario.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return TextFormField(
                            readOnly: true,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.book),
                                labelText: 'Número de cursos',
                                border: InputBorder.none),
                            controller: TextEditingController(
                                text: '${snapshot.data.docs.length}'),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
                // tilePadding: EdgeInsets.only(right: 10),
                subtitle: manageUserController.usuario.tipoUsuario == 'admin'
                    ? Text(
                        'Usuário administrador',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        '${manageUserController.cursoFuncionarioModel.cargo ?? ''}',
                        style: TextStyle(color: Colors.black),
                      ),
                title: Text(
                  '${manageUserController.pessoa.nome}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.green[300],
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            );
        }
      },
      future: manageUserController.recoveryDataUser(usuario),
    );
    ;
  }
}
