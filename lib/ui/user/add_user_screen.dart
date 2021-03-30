import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/manage_user_controller.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/ui/user/add_courses_user_screen.dart';
import 'package:egresso_ifpi/ui/user/tags/flutter_tag_view.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AddUserScreen extends StatelessWidget {
  TextEditingController nomeController;
  TextEditingController emailController;
  TextEditingController dataNascimentoController;
  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');

  final manageUserController = ManageUserController();
  final utilsController = GetIt.I.get<Utils>();
  final _formKey = GlobalKey<FormState>();
  final _scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    showMessage(String message) {
      _scafoldkey.currentState.showSnackBar(SnackBar(
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

    

    Widget formRegisterText(
        String label, TextEditingController controller, Function onChanged) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          validator: (text) => text.isEmpty ? 'Campo obrigatório' : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          controller: controller,
        ),
      );
    }

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text('Gerenciar usuários'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              formRegisterText(
                  'Nome', nomeController, manageUserController.pessoa.setNome),
              formRegisterText('Email', emailController,
                  manageUserController.pessoa.setEmail),
              formRegisterText(
                  'CPF', cpfController, manageUserController.pessoa.setCpf),
              // formRegisterText('Data Nascimento', dataNascimentoController,
              //     manageUserController.pessoa.setDataNascimento),
              Observer(
                builder: (_) {
                  return TextFormField(
                    readOnly: true,
                    validator: (text) =>
                        text.isEmpty ? 'Campo obrigatório' : null,
                    controller: TextEditingController(
                        text: manageUserController.pessoa.dataNascimento == null
                            ? ''
                            : ' ${utilsController.returnDateDefault(manageUserController.pessoa.dataNascimento)}'),
                    decoration: InputDecoration(
                        labelText: 'Data nascimento',
                        border: OutlineInputBorder()),
                    onTap: () async {
                      final pick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (pick != null) {
                        manageUserController.pessoa
                            .setDataNascimento(Timestamp.fromDate(pick));
                      }
                    },
                  );
                },
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
                      return 'Tipo de usuário obrigatório';
                    }
                  },
                  value: manageUserController.usuario.tipoUsuario,
                  isExpanded: true,
                  items: tipoUsuario(),
                  decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                      labelText: 'Tipo usuário'),
                  onChanged: manageUserController.usuario.setTipoUsuario),
              SizedBox(
                height: 10,
              ),
              
              Divider(),
              Observer(
                builder: (_) {
                  return manageUserController.coursesSelect.length > 0
                      ? FlutterTagView(
                          tags: manageUserController.coursesSelect,
                          maxTagViewHeight: 100,
                          deletableTag: false,
                          onDeleteTag: (a) {},
                          tagTitle: (a) {
                            return Text(
                              '${a.description}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            );
                          },
                        )
                      : Container();
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return AddCoursesUser(manageUserController);
                  }));
                },
                title: Text('Cursos'),
                subtitle: Text('Selecione os cursos do funcionário'),
                trailing: CircleAvatar(
                  child: Observer(
                    builder: (_) {
                      return Text(
                          '${manageUserController.coursesSelect.length}');
                    },
                  ),
                ),
              ),
              Divider(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.red[400],
                ),
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  child: Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (manageUserController.coursesSelect.length <= 0 &&
                        manageUserController.usuario.tipoUsuario ==
                            'funcionario') {
                      showMessage('Nenhum curso selecionado.');
                    } else if (_formKey.currentState.validate()) {
                      await manageUserController.save();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
