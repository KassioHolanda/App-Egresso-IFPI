import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/matricula.dart';
import 'package:mobx/mobx.dart';
part 'student.g.dart';

class StudentModel = _StudentModelBase with _$StudentModel;

abstract class _StudentModelBase with Store {
  @observable
  String uid;
  @observable
  String personUid;
  @observable
  Timestamp dateRegister;

  _StudentModelBase();

  _StudentModelBase.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    personUid = document.data()['pessoa_uid'];
    dateRegister = document.data()['data_cadastro'];
  }

  Map<String, dynamic> toMap() {
    return {
      'pessoa_uid': personUid,
      'data_cadastro': dateRegister,
    };
  }

  @action
  setUid(String value) => uid = value;
  @action
  setPessoaUid(String value) => personUid = value;
  @action
  setDataCadastro(Timestamp value) => dateRegister = value;
}
