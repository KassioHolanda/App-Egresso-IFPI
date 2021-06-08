import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'ocupacao.g.dart';

class Ocupacao = _OcupacaoBase with _$Ocupacao;

abstract class _OcupacaoBase with Store {
  @observable
  String uid;
  @observable
  String local;
  @observable
  bool isPaid = true;
  @observable
  Timestamp startAt;
  @observable
  String type;
  @observable
  Timestamp endAt;
  @observable
  String registrationUid;

  _OcupacaoBase();

  _OcupacaoBase.fromDocumento(DocumentSnapshot documento) {
    uid = documento.id;
    local = documento.data()['local'];
    isPaid = documento.data()['eh_remunerado'];
    startAt = documento.data()['data_inicio'];
    endAt = documento.data()['data_fim'];
    registrationUid = documento.data()['matricula_uid'];
    type = documento.data()['tipo_ocupacao'];
  }

  @action
  setLocal(String value) => local = value;
  @action
  setPaid(bool value) => isPaid = value;
  @action
  setStartAt(Timestamp value) => startAt = value;
  @action
  setEndAt(Timestamp value) => endAt = value;
  @action
  setRegistration(String value) => registrationUid = value;
  @action
  setType(String value) => type = value;

  toMap() {
    return {
      'local': local,
      'eh_remunerado': isPaid,
      'data_inicio': startAt,
      'data_fim': endAt,
      'matricula_uid': registrationUid,
      'tipo_ocupacao': type,
    };
  }
}
