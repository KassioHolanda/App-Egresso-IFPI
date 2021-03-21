import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'course.g.dart';

class CourseModel = _CourseModelBase with _$CourseModel;

abstract class _CourseModelBase with Store {
  @observable
  String uid;
  @observable
  String descricao;
  @observable
  String nivel;

  @action
  setUid(String value) => uid = value;

  @action
  setDescricao(String value) => descricao = value;

  @action
  setNivel(String value) => nivel = value;

  _CourseModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    descricao = documentSnapshot.data()['descricao'];
    nivel = documentSnapshot.data()['nivel'];
  }
}
