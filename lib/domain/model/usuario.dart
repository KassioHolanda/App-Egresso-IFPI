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

  @action
  setAuthUid(String value) => authUid = value;
  @action
  setPessoaUid(String value) => pessoaUid = value;
  @action
  setTipoUsuario(String value) => tipoUsuario = value;

  @action
  _UsuarioBase();

  @action
  _UsuarioBase.fromDocument(DocumentSnapshot documentSnapshot) {
    authUid = documentSnapshot.data()['auth_uid'];
    pessoaUid = documentSnapshot.data()['pessoa_uid'];
    tipoUsuario = documentSnapshot.data()['tipo_usuario'];
  }

Map<String, dynamic> toMap() {
    return {      
      'authUid': authUid,
      'pessoaUid': pessoaUid,
      'tipo_usuario': tipoUsuario,
    };
  }

}
