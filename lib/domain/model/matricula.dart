import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'matricula.g.dart';

class MatriculaModel = _MatriculaModelBase with _$MatriculaModel;

abstract class _MatriculaModelBase with Store {
  @observable
  String cursoUid;
  @observable
  Timestamp dataFim;
  @observable
  Timestamp dataInicio;
  @observable
  String status;
}
