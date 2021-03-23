import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DetailStudent extends StatelessWidget {
  final StudentModel student;

  final _formKey = GlobalKey<FormState>();
  final _scafoldkey = GlobalKey<ScaffoldState>();

  final utils = Utils();

  DetailStudent(this.student);

  @override
  Widget build(BuildContext context) {
    Widget formLabel(String title, TextEditingController controller,
        Function onChanged, Function validade) {
      return TextFormField(
        validator: validade,
        controller: controller,
        decoration:
            InputDecoration(labelText: title, border: OutlineInputBorder()),
      );
    }

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

    void showCoursesCreated() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.add)),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) {
                    if (utils.coursesFinded.length > 0) {
                      return ListTile(
                        trailing: Checkbox(
                          onChanged: (bool value) {},
                          value:
                              // utils.coursesFinded[index].uid == student.cursoUid
                              //     ? true
                              //     :
                              false,
                        ),
                        leading: Text('${index + 1}'),
                        title: Text(''),
                        subtitle: Text(''),
                      );
                    }
                    return Container();
                  },
                  itemCount: utils.coursesFinded.length,
                )
              ],
            ));
          });
    }

    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text('Detalhar aluno'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              formLabel('Nome', TextEditingController(text: ''), () {},
                  (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                }
              }),
              SizedBox(
                height: 10,
              ),
              formLabel('Email', TextEditingController(text: ''), () {},
                  (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                } else if (!text.contains('@')) {
                  return 'Email inválido.';
                }
              }),
              SizedBox(
                height: 10,
              ),
              formLabel('Matricula', TextEditingController(text: ''), () {},
                  (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                }
              }),
              SizedBox(
                height: 10,
              ),
              formLabel(
                  'Data nascimento', TextEditingController(text: ''), () {},
                  (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                }
              }),
              SizedBox(
                height: 10,
              ),
              formLabel(
                  'Status matricula', TextEditingController(text: ''), () {},
                  (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                }
              }),
              SizedBox(
                height: 10,
              ),
              formLabel(
                  'CPF',
                  MaskedTextController(
                      mask: '000.000.000-00', text: ''),
                  () {}, (String text) {
                if (text.isEmpty) {
                  return 'Campo obrigatório';
                }
              }),
              SizedBox(
                height: 10,
              ),
              TextField(
                readOnly: true,
                onTap: () {
                  showCoursesCreated();
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.edit),
                    labelText: 'Curso',
                    // enabled: false,
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.red[300],
                ),
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  child: Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {}
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
