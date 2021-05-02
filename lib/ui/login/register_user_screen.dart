import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:textfield_search/textfield_search.dart';

class RegisterUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = LoginController();
    final utilsController = GetIt.I.get<Utils>();

    final cursoController = TextEditingController();

    final _scafoldkey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();

    message(String message) {
      _scafoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        duration: new Duration(seconds: 5),
      ));
    }

    nextPage() {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    }

    Widget textForm(String label, Function onChanged) {
      return TextFormField(
        onChanged: onChanged,
        readOnly: label == 'Tipo usuário' ? true : false,
        controller: label == 'CPF'
            ? MaskedTextController(mask: '000.000.000-00')
            : TextEditingController(
                text: label == 'Tipo usuário' ? 'Aluno' : ''),
        enabled: label == 'Tipo usuário' ? false : true,
        validator: label == 'Email'
            ? (text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                } else if (!text.contains('@')) {
                  return 'Email inválido';
                }
              }
            : (text) => text.isEmpty ? 'Campo obrigatório' : null,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            helperStyle: TextStyle(color: Colors.grey[600]),
            helperText: label == 'Tipo usuário'
                ? 'Opção indisponível nesse cadastro'
                : null),
      );
    }

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text('Registrar usuário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Container(
              //   width: 80,
              //   height: 80,
              //   child: CircleAvatar(
              //     backgroundColor: Colors.green[100],
              //     child: Icon(
              //       Icons.person,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              textForm('Nome', loginController.pessoa.setNome),
              SizedBox(height: 10),
              textForm('Email', loginController.pessoa.setEmail),
              SizedBox(height: 10),
              textForm('CPF', loginController.pessoa.setCpf),
              SizedBox(height: 10),
              Observer(
                builder: (_) {
                  return TextFormField(
                    readOnly: true,
                    validator: (text) =>
                        text.isEmpty ? 'Campo obrigatório' : null,
                    controller: TextEditingController(
                        text: loginController.pessoa.dataNascimento == null
                            ? ''
                            : ' ${utilsController.returnDateDefault(loginController.pessoa.dataNascimento)}'),
                    decoration: InputDecoration(
                        labelText: 'Data nascimento',
                        border: OutlineInputBorder()),
                    onTap: () async {
                      final pick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (pick != null) {
                        loginController.pessoa
                            .setDataNascimento(Timestamp.fromDate(pick));
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: utilsController.returnAllCourses(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                          // child: Container(
                          //   child: CircularProgressIndicator(),
                          // ),
                          );
                    default:
                      return TextFieldSearch(
                          getSelectedValue: (value) {
                            loginController
                                .setCursoSelect(value != null ? true : false);
                            loginController.matricula.setCursoUid(value.uid);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Curso'),
                          future: () => utilsController.fetchData(),
                          // initialList: utilsController.fetchData(),
                          label: 'Curso',
                          controller: cursoController);
                  }
                },
              ),
              SizedBox(height: 10),
              textForm('Matrícula', loginController.matricula.setMatricula),
              SizedBox(height: 10),
              textForm('Tipo usuário', loginController.usuario.setTipoUsuario),
              SizedBox(height: 10),
              Observer(
                builder: (_) {
                  return TextFormField(
                    readOnly: true,
                    validator: (text) =>
                        text.isEmpty ? 'Campo obrigatório' : null,
                    controller: TextEditingController(
                        text: loginController.matricula.dataInicio == null
                            ? ''
                            : ' ${utilsController.returnDateDefault(loginController.matricula.dataInicio)}'),
                    decoration: InputDecoration(
                        helperText:
                            'Solicite com a coordenação caso não tenha conhecimento',
                        labelText: 'Data início curso',
                        border: OutlineInputBorder()),
                    onTap: () async {
                      final pick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (pick != null) {
                        loginController.matricula
                            .setDataIncicio(Timestamp.fromDate(pick));
                      }
                    },
                  );
                },
              ),

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.red,
                      ),
                      // width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        child: Text(
                          'Continuar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              loginController.cursoSelect) {
                            await loginController.save(
                                message, nextPage, '123456');
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
