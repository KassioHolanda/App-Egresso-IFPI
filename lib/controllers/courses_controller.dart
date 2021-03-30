import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'courses_controller.g.dart';

class CoursesController = _CoursesControllerBase with _$CoursesController;

abstract class _CoursesControllerBase with Store {
  @observable
  CursoModel course = CursoModel();

  final utilsController = GetIt.I.get<Utils>();

  @action
  setCourse(CursoModel cursoModel) => course = cursoModel;

  @action
  deleteCourse(Function message) async {
    try {
      utilsController.iniciarLoding();
      await FirebaseFirestore.instance
          .collection('curso')
          .doc(course.uid)
          .delete()
          .then((value) {
        message('Curso deletado');
        utilsController.encerrarLoading();
      });
    } catch (e) {
      utilsController.encerrarLoading();
      message('Erro ao deletar');
      print('ERRO - ${e.toString()}');
    }
  }

  @action
  saveCourse(Function message) async {
    try {
      utilsController.iniciarLoding();
      convertDescription();
      await FirebaseFirestore.instance
          .collection('curso')
          .add(course.toMap())
          .then((value) {
        utilsController.encerrarLoading();
        message('Curso salvo');
      });
    } catch (e) {
      utilsController.encerrarLoading();
      message('Erro ao salvar');
      print('ERRO - ${e.toString()}');
    }
  }

  convertDescription() {
    course.setDescription(
        '${course.description[0].toUpperCase()}${course.description.substring(1)}');
  }
}
