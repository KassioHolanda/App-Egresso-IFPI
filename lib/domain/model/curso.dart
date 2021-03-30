import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'curso.g.dart';

class CursoModel = _CursoModelBase with _$CursoModel;

abstract class _CursoModelBase with Store {
  @observable
  String uid;
  @observable
  String description;
  @observable
  String level;

  @action
  setUid(String value) => uid = value;

  @action
  setDescription(String value) => description = value;

  @action
  setLevel(String value) => level = value;

  _CursoModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    description = documentSnapshot.data()['descricao'];
    level = documentSnapshot.data()['nivel'];
  }
}
