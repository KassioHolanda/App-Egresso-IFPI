import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'course.g.dart';

class CourseModel = _CourseModelBase with _$CourseModel;

abstract class _CourseModelBase with Store {
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

  _CourseModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    description = documentSnapshot.data()['descricao'];
    level = documentSnapshot.data()['nivel'];
  }
}
