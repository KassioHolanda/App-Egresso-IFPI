import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/student.dart';
import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:mobx/mobx.dart';
part 'student_controller.g.dart';

class StudentController = _StudentControllerBase with _$StudentController;

abstract class _StudentControllerBase with Store {
  final authService = AuthService();

  saveStudent(StudentModel student) async {
    await FirebaseFirestore.instance
        .collection('alunos')
        .doc(student.pessoaUid)
        .update(student.toMap());
  }
}
