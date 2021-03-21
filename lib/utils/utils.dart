import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/course.dart';
import 'package:mobx/mobx.dart';
part 'utils.g.dart';

class Utils = _UtilsBase with _$Utils;

abstract class _UtilsBase with Store {
  @observable
  bool loading = false;

  @observable
  List<CourseModel> coursesFinded = new List();

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
        : dateTime.toDate().day;
    String month = dateTime.toDate().month < 10
        ? '0' + dateTime.toDate().month.toString()
        : dateTime.toDate().month;
    return '$day/$month/${dateTime.toDate().year}';
  }

  returnAllCourses() async {
    await FirebaseFirestore.instance
        .collection('cursos')
        .get()
        .then((QuerySnapshot value) {
      for (QueryDocumentSnapshot document in value.docs) {
        coursesFinded.add(CourseModel.fromDocument(document));
      }
    });
  }
}
