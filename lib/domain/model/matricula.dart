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
  String status;
  @observable
  String uid;

  @observable
  CursoModel cursoModel = CursoModel();

  _MatriculaModelBase();

  _MatriculaModelBase.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    matricula = document.data()['matricula'];
    dataFim = document.data()['data_fim'];
    dataInicio = document.data()['data_inicio'];
    status = document.data()['status'];
    cursoUid = document.data()['curso_uid'];
  }

  toMap() {
    return {
      'data_fim': dataFim,
      'data_inicio': dataInicio,
      'status': status,
      'matricula': matricula,
      'curso_uid': cursoUid,
    };
  }

  @action
  setDataFim(Timestamp value) => dataFim = value;
  @action
  setDataIncicio(Timestamp value) => dataInicio = value;
  @action
  setStatus(String value) => status = value;
  @action
  setMatricula(String value) => matricula = value;
  @action
  setCursoUid(String value) => cursoUid = value;
}
