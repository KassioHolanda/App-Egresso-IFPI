import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'user.g.dart';

class Usuario = _UsuarioBase with _$Usuario;

abstract class _UsuarioBase with Store {
  @observable
  String authUid;
  @observable
  String pessoaUid;
  @observable
  String tipoUsuario;

  _UsuarioBase();

  _UsuarioBase.fromDocument(DocumentSnapshot documentSnapshot) {
    authUid = documentSnapshot.data()['auth_uid'];
    pessoaUid = documentSnapshot.data()['pessoa_uid'];
    tipoUsuario = documentSnapshot.data()['tipo_usuario'];
  }
}
