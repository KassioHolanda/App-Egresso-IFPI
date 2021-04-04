import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/domain/model/funcionario.dart';
import 'package:mobx/mobx.dart';
part 'curso_funcionario.g.dart';

class CursoFuncionarioModel = _CursoFuncionarioModelBase
    with _$CursoFuncionarioModel;

abstract class _CursoFuncionarioModelBase with Store {
  @observable
  String uid;
  @observable
  String cargo;
  @observable
  String cursoUid;
  @observable
  String funcionarioUid;

  @observable
  CursoModel cursoModel;
  @observable
  FuncionarioModel funcionarioModel;

  _CursoFuncionarioModelBase();

  @action
  setCursoModel(CursoModel value) => cursoModel = value;
  @action
  setFuncionarioModel(FuncionarioModel value) => funcionarioModel = value;
  @action
  setFuncionarioUid(String value) => funcionarioUid = value;
  @action
  setCursoUid(String value) => cursoUid = value;
  @action
  setCargo(String value) => cargo = value;
  @action
  setCurso(CursoModel value) => cursoModel = value;

  _CursoFuncionarioModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    cargo = documentSnapshot.data()['cargo'];
    cursoUid = documentSnapshot.data()['curso_uid'];
    funcionarioUid = documentSnapshot.data()['funcionario_uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid,
      'cargo': cargo,
      'curso_uid': cursoUid,
      'funcionario_uid': funcionarioUid,
    };
  }
}
