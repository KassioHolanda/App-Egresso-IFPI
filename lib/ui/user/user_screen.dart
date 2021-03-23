import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/user_controller.dart';
import 'package:egresso_ifpi/domain/model/funcionario.dart';
import 'package:egresso_ifpi/domain/model/pessoa.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserScreen extends StatelessWidget {
  final userController = GetIt.I.get<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Usuários cadastrados'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
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
                        final funcionario =
                            FuncionarioModel.fromDocument(documents[index]);
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('pessoa')
                              .doc(funcionario.pessoaUid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              final pessoa =
                                  PessoaModel.fromDocument(snapshot.data);
                              return Card(
                                child: ExpansionTile(
                                  // tilePadding: EdgeInsets.only(right: 10),
                                  subtitle: userController.user.tipoUsuario ==
                                          'admin'
                                      ? Text('Usuário administrador')
                                      : FutureBuilder<QuerySnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('cursoFuncionario')
                                              .where('funcionario_uid',
                                                  isEqualTo: funcionario.uid)
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                                return Center();
                                              default:
                                                if (snapshot.hasData &&
                                                    snapshot.data.docs[0] !=
                                                        null) {
                                                  // print(snapshot.data);
                                                  return Text(
                                                      '${snapshot.data.docs[0]['cargo'].toUpperCase()}');
                                                }
                                                return Text(
                                                    'cargo não encontrado');
                                            }
                                          },
                                        ),
                                  title: Text(
                                    '${pessoa.nome}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  leading: CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        );
                      },
                      itemCount: documents.length,
                    );
                  }
                  return Container();
              }
            },
            future: FirebaseFirestore.instance.collection('funcionario').get(),
          )),
    );
  }
}
