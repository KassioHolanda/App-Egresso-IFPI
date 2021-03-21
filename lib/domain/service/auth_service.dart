import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  createLoginWithMail(String email, String senha) async {
    try {
      return await auth.createUserWithEmailAndPassword(email: email, password: senha);
      //     .then((value) {
      //   print('logado');
      // }).catchError((error) {
      //   print(error);
      //   print('error');
      // });

    } catch (e) {
      print(e);
    }
  }

  Future loginWithMail(String email, String senha) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: senha);
    //     .then((value) {
    //   print(value);
    // }).catchError((error) {
    //   print('erro');
    // });
  }

  Future recoveryPassword(String emailRecebido) async {
    await auth.sendPasswordResetEmail(email: emailRecebido);
  }

  @override
  Future logOut() async {
    await auth.signOut();
  }
}
