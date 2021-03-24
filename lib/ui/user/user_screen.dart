import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/funcionario.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/ui/user/add_user_screen.dart';
import 'package:egresso_ifpi/ui/user/cards/user_card.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return AddUserScreen();
          }));
        },
        child: Icon(Icons.add),
      ),
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
                        return UserCard(funcionario);
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
