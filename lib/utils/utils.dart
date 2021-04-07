import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'curso_aux.dart';
part 'utils.g.dart';

class Utils = _UtilsBase with _$Utils;

abstract class _UtilsBase with Store {
  @observable
  bool loading = false;

  @observable
  List<CursoModel> coursesFinded = new List();

  _UtilsBase() {
    returnAllCourses();
  }

  @action
  iniciarLoding() {
    loading = true;
  }

  @action
  encerrarLoading() {
    loading = false;
  }

  @action
  returnDateDefault(Timestamp dateTime) {
    String day = dateTime.toDate().day < 10
        ? '0' + dateTime.toDate().day.toString()
        : dateTime.toDate().day.toString();
    String month = dateTime.toDate().month < 10
        ? '0' + dateTime.toDate().month.toString()
        : dateTime.toDate().month.toString();
    return '$day/$month/${dateTime.toDate().year}';
  }

  returnAllCourses() async {
    coursesFinded = List();
    await FirebaseFirestore.instance
        .collection('curso')
        .get()
        .then((QuerySnapshot value) {
      for (QueryDocumentSnapshot document in value.docs) {
        coursesFinded.add(CursoModel.fromDocument(document));
      }
    });
  }

  Future<List> fetchData() async {
    List _list = new List();
    for (CursoModel c in coursesFinded) {
      _list.add(Curso(c.uid, c.description, c.level));
    }
    return _list;
  }

  isAdminUser() async {
    final preffs = await SharedPreferences.getInstance();
    return preffs.getBool('admin');
  }
}
