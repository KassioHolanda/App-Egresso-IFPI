import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future createLoginWithMail(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      //     .then((value) {
      //   print('logado');
      // }).catchError((error) {
      //   print(error);
      //   print('error');
      // });

      return;
    } catch (e) {
      print(e);
    }
  }

  Future loginWithMail(String email, String senha) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: senha);
    //     .then((value) {
    //   print(value);
    // }).catchError((error) {
    //   print('erro');
    // });
  }

  Future recoveryPassword(String emailRecebido) async {
    await _auth.sendPasswordResetEmail(email: emailRecebido);
  }

  @override
  Future logOut() async {
    await _auth.signOut();
  }
}
