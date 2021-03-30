import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/user_controller.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/domain/model/curso_funcionario.dart';
import 'package:egresso_ifpi/domain/model/funcionario.dart';
import 'package:egresso_ifpi/domain/model/pessoa.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'manage_user_controller.g.dart';

class ManageUserController = _ManageUserControllerBase
    with _$ManageUserController;

abstract class _ManageUserControllerBase with Store {
  final userController = GetIt.I.get<UserController>();

  @observable
  ObservableList<dynamic> coursesSelect = ObservableList().asObservable();
  @observable
  Usuario usuario = Usuario();
  @observable
  PessoaModel pessoa = PessoaModel();
  @observable
  FuncionarioModel funcionario = FuncionarioModel();
  @observable
  List<CursoFuncionarioModel> coursesEmployee = List();
  @observable
  CursoFuncionarioModel cursoFuncionarioModel = CursoFuncionarioModel();

  @action
  manageCourseUser(CursoModel course) {
    if (!isCourseSelect(course)) {
      coursesSelect.add(course);
    } else {
      coursesSelect.remove(course);
    }
  }

  @action
  bool isCourseSelect(CursoModel course) {
    for (CursoModel c in coursesSelect) {
      if (c.uid == course.uid) {
        return true;
      }
    }
    return false;
  }

  @action
  save() async {
    try {
      if (usuario.tipoUsuario == 'funcionario') {
        savePerson();
        saveEmployee();
        saveCourseEmployee();
        saveUser();
      } else if (usuario.tipoUsuario == 'admin') {}
    } catch (e) {}
  }

  @action
  saveEmployee() async {
    await FirebaseFirestore.instance
        .collection('funcionario')
        .add(funcionario.toMap())
        .then((value) async {
      cursoFuncionarioModel.setFuncionarioUid(value.id);
      await saveCourseEmployee();
    });
  }

  @action
  saveCourseEmployee() async {
    await FirebaseFirestore.instance
        .collection('cursoFuncionario')
        .add(cursoFuncionarioModel.toMap());
  }

  @action
  savePerson() async {
    await FirebaseFirestore.instance
        .collection('pessoa')
        .add(pessoa.toMap())
        .then((value) async {
      usuario.setPessoaUid(value.id);
      funcionario.setPessoaUid(value.id);
      await saveUser();
    });
  }

  @action
  saveUser() async {
    await FirebaseFirestore.instance.collection('usuario').add(usuario.toMap());
  }

  @action
  recoveryDataUser(Usuario usuario) async {
    this.usuario = usuario;

    await recoveryUser();
    await recoveryEmployee();
    await recorevyEmployeeCourses();
  }

  @action
  recoveryUser() async {
    await FirebaseFirestore.instance
        .collection('pessoa')
        .doc(usuario.pessoaUid)
        .get()
        .then((value) => pessoa = PessoaModel.fromDocument(value));
  }

  @action
  recorevyEmployeeCourses() async {
    await FirebaseFirestore.instance
        .collection('cursoFuncionario')
        .where('funcionario_uid', isEqualTo: funcionario.uid)
        .get()
        .then((value) {
      for (DocumentSnapshot doc in value.docs) {
        coursesEmployee.add(CursoFuncionarioModel.fromDocument(doc));
      }
    });

    for (CursoFuncionarioModel cf in coursesEmployee) {
      await FirebaseFirestore.instance
          .collection('curso')
          .doc(cf.cursoUid)
          .get()
          .then((value) => coursesSelect.add(CursoModel.fromDocument(value)));
    }
  }

  @action
  recoveryEmployee() async {
    await FirebaseFirestore.instance
        .collection('funcionario')
        .where('pessoa_uid', isEqualTo: usuario.pessoaUid)
        .get()
        .then((value) {
      if (value.docs.length > 0)
        funcionario = FuncionarioModel.fromDocument(value.docs[0]);
    });
  }

  // recoveryCourses(documentSnapshot) {
  //   List<DropdownMenuItem<List<CursoModel>>> cursos = List();
    
  //   for (DocumentSnapshot doc in documentSnapshot) {
  //     final curso = CursoModel.fromDocument(doc);
  //     cursos.add(DropdownMenuItem(
  //       value: curso,
  //       child: Text(
  //         '${curso.description}',
  //         style: TextStyle(color: Colors.black),
  //       ),
  //     ));
  //   }
  //   return cursos;
  // }
}
