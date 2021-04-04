import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/manage_user_controller.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class MyDataScreen extends StatelessWidget {
  final manageUserController = ManageUserController();
  final utilsController = GetIt.I.get<Utils>();

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget form(String label, String text, Function onChanged) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onChanged: onChanged,
        validator: (text) =>
            text.isEmpty ? 'Esse campo não pode fica em branco' : null,
        controller: label == 'CPF'
            ? MaskedTextController(
                mask: '000.000.000-00', text: text == null ? '' : text)
            : TextEditingController(text: text == null ? '' : text),
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

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

    List<DropdownMenuItem<String>> tipoUsuario() {
      List<DropdownMenuItem<String>> itens = List();
      itens.add(DropdownMenuItem(
        value: 'funcionario',
        child: Text(
          'Funcionário',
          style: TextStyle(color: Colors.black),
        ),
      ));
      itens.add(DropdownMenuItem(
        value: 'admin',
        child: Text(
          'Administrador',
          style: TextStyle(color: Colors.black),
        ),
      ));

      return itens;
    }

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

    showSelectOfficeAnCourse() {
      showDialog(
          context: context,
          builder: (_) {
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
                    onPressed: () {},
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
                      value: manageUserController.cursoFuncionarioModel.cargo,
                      isExpanded: true,
                      items: tipoCargo(),
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(),
                          labelText: 'Cargo'),
                      onChanged:
                          manageUserController.cursoFuncionarioModel.setCargo),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: utilsController.returnAllCourses(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        default:
                          return TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Curso',
                                suffixIcon: Icon(Icons.search),
                                border: OutlineInputBorder()),
                          );
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Meus dados'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: manageUserController.recoveryDataUser(null),
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
                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      form('Nome', manageUserController.pessoa.nome,
                          manageUserController.pessoa.setNome),
                      form('Email', manageUserController.pessoa.email,
                          manageUserController.pessoa.setEmail),
                      form('CPF', manageUserController.pessoa.cpf,
                          manageUserController.pessoa.setCpf),
                      Observer(
                        builder: (_) {
                          return TextFormField(
                            readOnly: true,
                            validator: (text) =>
                                text.isEmpty ? 'Campo obrigatório' : null,
                            controller: TextEditingController(
                                text: manageUserController
                                            .pessoa.dataNascimento ==
                                        null
                                    ? ''
                                    : ' ${utilsController.returnDateDefault(manageUserController.pessoa.dataNascimento)}'),
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
                                manageUserController.pessoa.setDataNascimento(
                                    Timestamp.fromDate(pick));
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tipo usuário'),
                        readOnly: true,
                        enabled: false,
                        controller: TextEditingController(
                            text: manageUserController.usuario.tipoUsuario ==
                                    'admin'
                                ? 'Administrador'
                                : 'Funcionario'),
                      ),
                      Divider(),
                      manageUserController.usuario.tipoUsuario == 'admin'
                          ? Container()
                          : ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Cargos'),
                              subtitle:
                                  Text('Cursos cadastrados para o usuário'),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  showSelectOfficeAnCourse();
                                },
                              ),
                            ),
                      manageUserController.usuario.tipoUsuario != 'admin'
                          ? SizedBox(
                              height: 10,
                            )
                          : Container(),
                      manageUserController.coursesEmployee.length > 0 &&
                              manageUserController.usuario.tipoUsuario !=
                                  'admin'
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  manageUserController.coursesEmployee.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                      '${manageUserController.coursesEmployee[index].cargo != '' ? manageUserController.coursesEmployee[index].cargo : "Administrador"}'),
                                  subtitle: Text(
                                      '${manageUserController.coursesEmployee[index].cursoModel.description}'),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Nenhum curso informado para esse usuário.'),
                            ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.red[400],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Observer(
                          builder: (_) {
                            return FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  manageUserController.utils.loading
                                      ? Container(
                                          padding: EdgeInsets.only(right: 10),
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    'Atualizar',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: manageUserController.utils.loading
                                  ? null
                                  : () async {
                                      if (formKey.currentState.validate()) {
                                        await manageUserController
                                            .update(showMessage);
                                      }
                                    },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
