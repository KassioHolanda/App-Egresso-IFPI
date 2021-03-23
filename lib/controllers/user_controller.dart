import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_controller.g.dart';

class UserController = _UserControllerBase with _$UserController;

abstract class _UserControllerBase with Store {
  Usuario user;

  recoveryUserFromAuth(String authUid) async {
    await FirebaseFirestore.instance
        .collection('usuario')
        .where('auth_uid', isEqualTo: authUid)
        .get()
        .then((QuerySnapshot value) {
      if (value.docs.length > 0) {
        user = Usuario.fromDocument(value.docs[0]);
        savePreferences(user);
      }
    });
  }

  savePreferences(user) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('auth_uid', user.authUid);
    await _prefs.setBool('admin', user.tipoUsuario == 'admin');
    await _prefs.setString('pessoa_uid', user.pessoaUid);
  }
}
