import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/user_controller.dart';
import 'package:egresso_ifpi/domain/model/funcionario.dart';
import 'package:egresso_ifpi/domain/model/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get_it/get_it.dart';

class UserCard extends StatelessWidget {
  final userController = GetIt.I.get<UserController>();

  final FuncionarioModel funcionario;

  UserCard(this.funcionario);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('pessoa')
          .doc(funcionario.pessoaUid)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final pessoa = PessoaModel.fromDocument(snapshot.data);
          return Card(
            child: ExpansionTile(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: 'Email',
                        border: InputBorder.none),
                    controller: TextEditingController(
                      text: '${pessoa.email}',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_pin_rounded),
                        labelText: 'CPF',
                        border: InputBorder.none),
                    controller: MaskedTextController(
                        text: '${pessoa.cpf}', mask: '000.000.000-00'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('cursoFuncionario')
                        .where('funcionario_uid', isEqualTo: funcionario.uid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return TextFormField(
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
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: FlatButton(
                      color: Colors.blue,
                      onPressed: () {},
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: FlatButton(
                      color: Colors.red,
                      onPressed: () {},
                      child: Text(
                        'Remover',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
              // tilePadding: EdgeInsets.only(right: 10),
              subtitle: userController.user.tipoUsuario == 'admin'
                  ? Text(
                      'Usuário administrador',
                      style: TextStyle(color: Colors.black),
                    )
                  : FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('cursoFuncionario')
                          .where('funcionario_uid', isEqualTo: funcionario.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center();
                          default:
                            if (snapshot.hasData &&
                                snapshot.data.docs[0] != null) {
                              // print(snapshot.data);
                              return Text(
                                '${snapshot.data.docs[0]['cargo'].toUpperCase()}',
                                style: TextStyle(color: Colors.black),
                              );
                            }
                            return Text(
                              'cargo não encontrado',
                              style: TextStyle(color: Colors.black),
                            );
                        }
                      },
                    ),
              title: Text(
                '${pessoa.nome}',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
        return Container();
      },
    );
  }
}
