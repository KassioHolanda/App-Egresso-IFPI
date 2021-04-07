import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/matricula.dart';
import 'package:mobx/mobx.dart';
part 'student.g.dart';

class StudentModel = _StudentModelBase with _$StudentModel;

abstract class _StudentModelBase with Store {
  @observable
  String personUid;
  @observable
  Timestamp dateRegister;
  @observable
  String matriculaUid;

  @observable
  MatriculaModel matricula;

  _StudentModelBase();

  _StudentModelBase.fromDocument(DocumentSnapshot document) {
    personUid = document.data()['pessoa_uid'];
    dateRegister = document.data()['data_cadastro'];
    matriculaUid = document.data()['matricula_uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'pessoa_uid': personUid,
      'matricula_uid': matriculaUid,
      'data_cadastro': dateRegister,
    };
  }

  @action
  setPessoaUid(String value) => personUid = value;
  @action
  setDataCadastro(Timestamp value) => dateRegister = value;
  @action
  setMatriculaUid(String value) => matriculaUid = value;
}
