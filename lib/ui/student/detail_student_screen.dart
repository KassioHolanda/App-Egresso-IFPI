import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/controllers/student_controller.dart';
import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/domain/model/matricula.dart';
import 'package:egresso_ifpi/domain/model/ocupacao.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:textfield_search/textfield_search.dart';

class DetailStudent extends StatelessWidget {
  StudentController studentController;

  final bool alunoLogado;

  final _formKey = GlobalKey<FormState>();
  final _scafoldkey = GlobalKey<ScaffoldState>();
  final loginController = LoginController();

  DetailStudent({StudentController studentC, this.alunoLogado = false}) {
    if (studentC != null) {
      studentController = studentC;
    } else {
      studentController = StudentController(true);
    }
  }

  List<DropdownMenuItem<String>> statusMatriculas() {
    List<DropdownMenuItem<String>> itens = List();
    itens.add(DropdownMenuItem(
      value: 'cancelado',
      child: Text(
        'Cancelado',
        style: TextStyle(color: Colors.black),
      ),
    ));
    itens.add(DropdownMenuItem(
      value: 'concluido',
      child: Text(
        'Concluído',
        style: TextStyle(color: Colors.black),
      ),
    ));
    itens.add(DropdownMenuItem(
      value: 'desistente',
      child: Text(
        'Desistente',
        style: TextStyle(color: Colors.black),
      ),
    ));
    itens.add(DropdownMenuItem(
      value: 'em_andamento',
      child: Text(
        'Em andamento',
        style: TextStyle(color: Colors.black),
      ),
    ));

    return itens;
  }

  @override
  Widget build(BuildContext context) {
    fecharpagina() {
      Navigator.pop(context);
    }

    List<DropdownMenuItem<String>> matriculas() {
      List<DropdownMenuItem<String>> itens = List();

      for (MatriculaModel m in studentController.matriculas) {
        itens.add(DropdownMenuItem(
          value: m.uid,
          child: Text(
            m.matricula.toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ));
      }
      return itens;
    }

    Widget formLabel(String title, TextEditingController controller,
        Function onChanged, Function validade, bool readOnly) {
      return TextFormField(
        readOnly: readOnly,
        validator: validade,
        controller: controller,
        onChanged: onChanged,
        decoration:
            InputDecoration(labelText: title, border: OutlineInputBorder()),
      );
    }

    addMatricula() {
      showDialog(
          context: context,
          builder: (_) {
            final formKey = GlobalKey<FormState>();
            final cursoController = TextEditingController();
            MatriculaModel matriculaModel = MatriculaModel();

            bool isCourse = false;

            return Dialog(
              // title:
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Adicionar Matrícula',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onChanged: matriculaModel.setMatricula,
                        decoration: InputDecoration(
                            labelText: 'Número matricula',
                            border: OutlineInputBorder()),
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'Esse campo não pode ficar em branco.';
                          } else if (!studentController
                              .isValidMatricula(text)) {
                            return 'Matricula já cadastrada para esse aluno.';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Observer(
                        builder: (_) {
                          return TextFormField(
                            readOnly: true,
                            validator: (text) =>
                                text.isEmpty ? 'Campo obrigatório' : null,
                            controller: TextEditingController(
                                text: matriculaModel.dataInicio == null
                                    ? ''
                                    : ' ${studentController.utilsController.returnDateDefault(matriculaModel.dataInicio)}'),
                            decoration: InputDecoration(
                                labelText: 'Data início',
                                border: OutlineInputBorder()),
                            onTap: () async {
                              final pick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                              if (pick != null) {
                                matriculaModel
                                    .setDataIncicio(Timestamp.fromDate(pick));
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: studentController.utilsController
                            .returnAllCourses(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Container();
                            default:
                              return TextFieldSearch(
                                  getSelectedValue: (value) {
                                    value != null
                                        ? isCourse = true
                                        : isCourse = false;
                                    matriculaModel.setCursoUid(
                                        value != null ? value.uid : null);
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Curso'),
                                  future: () => studentController
                                      .utilsController
                                      .fetchData(),
                                  label: 'Curso',
                                  controller: cursoController);
                          }
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     FlatButton(
                      //       onPressed: () async {

                      //       },
                      //       child: Text(
                      //         'Salvar',
                      //         style: TextStyle(color: Colors.blue),
                      //       ),
                      //     ),
                      //     // SizedBox(
                      //     //   width: 10,
                      //     // ),
                      //     FlatButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //         child: Text(
                      //           'Cancelar',
                      //           style: TextStyle(color: Colors.red),
                      //         ))
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.green,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              await studentController
                                  .addMatriculaStudent(matriculaModel);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.red,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              // actions: [

              // ],
            );
          });
    }

    addOccupations() {
      showDialog(
          context: context,
          builder: (_) {
            final formKey = GlobalKey<FormState>();
            Ocupacao ocupacao = Ocupacao();

            return Dialog(
              // title:
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Adicionar Ocupação',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onChanged: ocupacao.setLocal,
                        decoration: InputDecoration(
                            labelText: 'Local', border: OutlineInputBorder()),
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'Esse campo não pode ficar em branco.';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Observer(
                        builder: (_) {
                          return TextFormField(
                            readOnly: true,
                            validator: (text) =>
                                text.isEmpty ? 'Campo obrigatório' : null,
                            controller: TextEditingController(
                                text: ocupacao.startAt == null
                                    ? ''
                                    : ' ${studentController.utilsController.returnDateDefault(ocupacao.startAt)}'),
                            decoration: InputDecoration(
                                labelText: 'Data de início',
                                border: OutlineInputBorder()),
                            onTap: () async {
                              final pick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(5000));
                              if (pick != null) {
                                ocupacao.setStartAt(Timestamp.fromDate(pick));
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Observer(
                        builder: (_) {
                          return TextFormField(
                            readOnly: true,
                            validator: (text) =>
                                text.isEmpty ? 'Campo obrigatório' : null,
                            controller: TextEditingController(
                                text: ocupacao.endAt == null
                                    ? ''
                                    : ' ${studentController.utilsController.returnDateDefault(ocupacao.endAt)}'),
                            decoration: InputDecoration(
                                labelText: 'Data de encerramento',
                                border: OutlineInputBorder()),
                            onTap: () async {
                              final pick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(5000));
                              if (pick != null) {
                                ocupacao.setEndAt(Timestamp.fromDate(pick));
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Observer(
                        builder: (_) {
                          return Row(
                            children: [
                              Switch(
                                  value: ocupacao.isPaid,
                                  onChanged: ocupacao.setPaid),
                              Text('É Remunerado?  ')
                            ],
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
                              return 'Matricula obrigatória';
                            }
                          },
                          value: ocupacao.registrationUid,
                          isExpanded: true,
                          items: matriculas(),
                          decoration: InputDecoration(
                              // prefixIcon: Icon(Icons.credit_card),
                              border: OutlineInputBorder(),
                              labelText: 'Matricula'),
                          onChanged: ocupacao.setRegistration),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.green,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              await studentController.addOccupations(ocupacao);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.red,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              // actions: [

              // ],
            );
          });
    }

    showOptions() {
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // title: Text('Adicionar'),
              // padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        addMatricula();
                      },
                      title: Text('Matrícula'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        addOccupations();
                      },
                      title: Text('Ocupação'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            );
          });
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

    if (alunoLogado) {
      studentController
          .getDataStudent(loginController.userController.user.pessoaUid);
    }

    return Scaffold(
      drawer: loginController.userController.user.tipoUsuario == 'aluno'
          ? DrawerConfig()
          : null,
      key: _scafoldkey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                showOptions();
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
        title:
            Text(studentController.student != null ? 'Detalhar' : 'Adicionar'),
      ),
      body: Observer(
        builder: (_) {
          return studentController.loading
              ? Container()
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            'DADOS PESSOAIS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            readOnly: studentController.person.uid != null,
                            controller: TextEditingController(
                                text: studentController.person.nome ?? ''),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Nome',
                                hintText: 'Qual nome do aluno?',
                                border: OutlineInputBorder()),
                            onChanged: studentController.person.setNome,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Campo obrigatório';
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            readOnly: studentController.person.uid != null,
                            controller: TextEditingController(
                                text: studentController.person.email ?? ''),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail_sharp),
                                labelText: 'Email',
                                hintText:
                                    'Email utilizado para realizar o login.',
                                border: OutlineInputBorder()),
                            onChanged: studentController.person.setEmail,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Campo obrigatório.';
                              } else if (!text.contains('@') ||
                                  !text.contains('.')) {
                                return 'Email inválido.';
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Senha padrão de acesso "ifpi123"'),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            readOnly: studentController.person.uid != null,
                            controller: MaskedTextController(
                                mask: '(00) 00000-0000',
                                text: studentController.person.telefone ?? ''),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Telefone',
                                border: OutlineInputBorder()),
                            onChanged: studentController.person.setTelefone,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Campo obrigatório';
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Observer(
                          builder: (_) {
                            return TextFormField(
                              readOnly: true,
                              validator: (text) =>
                                  text.isEmpty ? 'Campo obrigatório' : null,
                              controller: studentController
                                          .person.dataNascimento ==
                                      null
                                  ? TextEditingController(text: '')
                                  : TextEditingController(
                                      text: studentController.utilsController
                                          .returnDateDefault(studentController
                                              .person.dataNascimento)),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.date_range_rounded),
                                  labelText: 'Data nascimento',
                                  border: OutlineInputBorder()),
                              onTap: studentController.newStudent
                                  ? () async {
                                      final pick = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now());
                                      if (pick != null) {
                                        studentController.person
                                            .setDataNascimento(
                                                Timestamp.fromDate(pick));
                                      }
                                    }
                                  : null,
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            readOnly: studentController.person.uid != null,
                            controller: MaskedTextController(
                                mask: '000.000.000-00',
                                text: studentController.person.cpf ?? ''),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.book_rounded),
                                labelText: 'CPF',
                                border: OutlineInputBorder()),
                            onChanged: studentController.person.setCpf,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'Campo obrigatório';
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26),
                              child: Text(
                                'MATRICULAS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Observer(
                          builder: (_) {
                            return studentController.matriculas.length == 0
                                ? Container(
                                    child: Text(
                                      'Nenhuma matricula cadastrada.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: studentController
                                                          .matriculas[index]
                                                          .status ==
                                                      'em_andamento'
                                                  ? Colors.green[200]
                                                  : Colors.red[200],
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ExpansionTile(
                                          // initiallyExpanded: studentController
                                          //         .matriculas[index].status ==
                                          //     'em_andamento',
                                          childrenPadding: EdgeInsets.all(10),
                                          title: ListTile(
                                            title: Text(
                                              '${studentController.matriculas[index].matricula.toString().toUpperCase()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                '${studentController.matriculas[index].status != "em_andamento" ? "Encerrada em: " + studentController.utilsController.returnDateDefault(studentController.matriculas[index].dataFim) : "Iniciado em: " + studentController.utilsController.returnDateDefault(studentController.matriculas[index].dataInicio)}'),
                                          ),
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            formLabel(
                                                'Matricula',
                                                TextEditingController(
                                                    text:
                                                        '${studentController.matriculas[index].matricula.toString().toUpperCase()}'),
                                                (text) {}, (String text) {
                                              if (text.isEmpty) {
                                                return 'Campo obrigatório';
                                              }
                                            }, true),
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
                                                    return 'Status matricula obrigatória';
                                                  }
                                                },
                                                value: studentController
                                                    .matriculas[index].status,
                                                isExpanded: true,
                                                items: statusMatriculas(),
                                                decoration: InputDecoration(
                                                    // prefixIcon: Icon(Icons.credit_card),
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Status matricula'),
                                                onChanged: studentController
                                                    .matriculas[index]
                                                    .setStatus),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            formLabel(
                                              'Curso',
                                              TextEditingController(
                                                  text:
                                                      '${studentController.matriculas[index].curso.description}'),
                                              (text) {},
                                              (String text) {
                                                if (text.isEmpty) {
                                                  return 'Campo obrigatório';
                                                }
                                              },
                                              true,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            studentController.matriculas[index]
                                                            .status !=
                                                        'em_andamento' &&
                                                    studentController
                                                            .matriculas[index]
                                                            .dataFim !=
                                                        null
                                                ? formLabel(
                                                    'Data de término',
                                                    TextEditingController(
                                                        text:
                                                            '${studentController.utilsController.returnDateDefault(studentController.matriculas[index].dataFim)}'),
                                                    (text) {}, (String text) {
                                                    if (text.isEmpty) {
                                                      return 'Campo obrigatório';
                                                    }
                                                  },
                                                    studentController
                                                            .matriculas[index]
                                                            .status !=
                                                        'em_andamento')
                                                : Container()
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount:
                                        studentController.matriculas.length,
                                    shrinkWrap: true,
                                  );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26),
                              child: Text(
                                'OCUPAÇÕES',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Observer(
                          builder: (_) {
                            return studentController.occupations.length == 0
                                ? Container(
                                    child: Text(
                                      'Nenhuma ocupação cadastrada.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Ocupacao ocupacao =
                                          studentController.occupations[index];
                                      return Container(
                                        child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.grey[200],
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            title: Text('${ocupacao.local}'),
                                            subtitle: Text(
                                                'Data início ${ocupacao.startAt != null ? studentController.utilsController.returnDateDefault(ocupacao.startAt) : 'Não informado'}, Data fim ${ocupacao.endAt != null ? studentController.utilsController.returnDateDefault(ocupacao.endAt) : 'Não informado'}'),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        studentController.occupations.length,
                                  );
                          },
                        ),
                        SizedBox(height: 20),
                        Observer(
                          builder: (_) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: studentController.utilsController.loading
                                    ? Colors.red[200]
                                    : Colors.red,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    studentController.utilsController.loading
                                        ? Container(
                                            width: 20,
                                            margin: EdgeInsets.only(right: 10),
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : Container(
                                            width: 0,
                                          ),
                                    Text(
                                      studentController.newStudent
                                          ? 'Salvar'
                                          : 'Atualizar cadastro',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                onPressed: studentController
                                        .utilsController.loading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState.validate()) {
                                          if (studentController
                                                  .matriculas.length ==
                                              0) {
                                            showMessage(
                                                'Adicione pelo menos uma matricula.');
                                          } else {
                                            await studentController.save(
                                                showMessage, fecharpagina);
                                            await Future.delayed(
                                                Duration(seconds: 3));
                                          }
                                        }
                                      },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
