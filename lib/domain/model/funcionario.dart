import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'funcionario.g.dart';

class FuncionarioModel = _FuncionarioModelBase with _$FuncionarioModel;

abstract class _FuncionarioModelBase with Store {
  @observable
  String uid;
  @observable
  String pessoaUid;

  @action
  setUid(String value) => uid = value;
  @action
  setPessoaUid(String value) => pessoaUid = value;

  _FuncionarioModelBase();

  _FuncionarioModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    pessoaUid = documentSnapshot.data()['pessoa_uid'];
  }

  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid,
      'pessoa_uid': pessoaUid,
    };
  }
}
