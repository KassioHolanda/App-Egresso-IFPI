import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:mobx/mobx.dart';
part 'matricula.g.dart';

class MatriculaModel = _MatriculaModelBase with _$MatriculaModel;

abstract class _MatriculaModelBase with Store {
  @observable
  String cursoUid;
  @observable
  String matricula;
  @observable
  Timestamp dataFim;
  @observable
  Timestamp dataInicio;
  @observable
  Timestamp dataCadastro;
  @observable
  String status;
  @observable
  String uid;
  @observable
  String alunoUid;
  @observable
  CursoModel curso = CursoModel();

  _MatriculaModelBase();

  _MatriculaModelBase.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    matricula = document.data()['numero_matricula'];
    dataFim = document.data()['data_fim'];
    dataInicio = document.data()['data_inicio'];
    dataCadastro = document.data()['data_cadastro'];
    status = document.data()['status_matricula'];
    cursoUid = document.data()['curso_uid'];
    alunoUid = document.data()['aluno_uid'];
  }

  toMap() {
    return {
      'data_fim': dataFim,
      'data_inicio': dataInicio,
      'data_cadastro': dataCadastro,
      'status_matricula': status,
      'numero_matricula': matricula,
      'curso_uid': cursoUid,
      'aluno_uid': alunoUid,
    };
  }

  @action
  setAlunoUid(String value) => alunoUid = value;
  @action
  setDataFim(Timestamp value) => dataFim = value;
  @action
  setDataCadastro(Timestamp value) => dataCadastro = value;
  @action
  setDataIncicio(Timestamp value) => dataInicio = value;
  @action
  setStatus(String value) => status = value;
  @action
  setMatricula(String value) => matricula = value;
  @action
  setCursoUid(String value) => cursoUid = value;
}
