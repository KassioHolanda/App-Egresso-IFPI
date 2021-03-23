import 'package:cloud_firestore/cloud_firestore.dart';
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

  _StudentModelBase();

  _StudentModelBase.fromDocument(DocumentSnapshot document) {
    personUid = document.data()['pessoa_uid'];
    dateRegister = document.data()['data_cadastro'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dataCadastro': dateRegister,
    };
  }
}
