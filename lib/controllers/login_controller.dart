import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/controllers/user_controller.dart';
import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/domain/model/matricula.dart';
import 'package:egresso_ifpi/domain/model/pessoa.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final authService = AuthService();
  final utils = GetIt.I.get<Utils>();
  final userController = GetIt.I.get<UserController>();

  @observable
  String senha = '';

  @observable
  bool cursoSelect = false;

  @observable
  Usuario usuario = Usuario();
  @observable
  PessoaModel pessoa = PessoaModel();
  @observable
  StudentModel student = StudentModel();
  @observable
  MatriculaModel matricula = MatriculaModel();

  @observable
  bool loading = false;

  @action
  setSenha(value) => senha = value;

  @action
  setCursoSelect(value) => cursoSelect = value;

  // verificarSeUsuarioEstaCadastrado(
  //     String email, String password, Function message, Function action) async {
  //   try {
  //     utils.iniciarLoding();
  //     await FirebaseFirestore.instance
  //         .collection('pessoa')
  //         .where('email', isEqualTo: email)
  //         .get()
  //         .then((value) {
  //       if (value.docs.length > 0) {
  //         authService.loginWithMail(email, password).then((value) async {
  //           utils.encerrarLoading();
  //           UserCredential usuario = value;
  //           await userController.recoveryUserFromAuth(usuario.user.uid);

  //           action();
  //         }).catchError((error) {
  //           print('erro encontrado  $error');
  //           utils.encerrarLoading();
  //           message(validateErrorsLogin(error.code));
  //         });
  //         // authService.createLoginWithMail(email, password).then((value) async {
  //         //   UserCredential usuario = value;
  //         //   saveUser(usuario.user.uid);
  //         //   await userController.recoveryUserFromAuth(usuario.user.uid);
  //         //   action();
  //         // }).catchError((error) {
  //         //   print('ENTROU NO ERRO');
  //         //   print(error.code);
  //         //   if (error == 'email-already-in-use') {
  //         //     print('ENTROU NO ERRO');
  //         //   }
  //         // });
  //         // loginComEmail(email, password, message, action);
  //       } else {
  //         message('N??o foi encontrado nenhum cadastro para esse usu??rio.');
  //       }
  //     });
  //     utils.encerrarLoading();
  //   } catch (e) {
  //     utils.encerrarLoading();
  //     message('Ocorreu um erro, tente novamente.');
  //   }
  // }

  @action
  Future recuperarSenhaUsuario(String email) async {
    await authService.recuperarSenha(email);
  }

  @action
  loginComEmail(
      String email, String password, Function message, Function action) async {
    utils.iniciarLoding();
    await authService.loginWithMail(email, password).then((value) async {
      utils.encerrarLoading();
      UserCredential usuario = value;
      await userController.recoveryUserFromAuth(usuario.user.uid);

      action();
    }).catchError((error) {
      print('erro encontrado  $error');
      utils.encerrarLoading();
      message(validateErrorsLogin(error.code));
    });
  }

  logoutUser() async {
    await authService.logOut();
  }

  isLoggedIn(Function loginUser, Function loginPage) async {
    if (authService.auth.currentUser != null) {
      await userController
          .recoveryUserFromAuth(authService.auth.currentUser.uid);
      loginUser();
    } else {
      loginPage();
    }
  }

  @action
  recoverDataUser() async {}

  @action
  createLogin(String password, Function nextPage) async {
    authService.createLoginWithMail(pessoa.email, password).then((value) async {
      UserCredential usuario = value;
      saveUser(usuario.user.uid);
      await userController.recoveryUserFromAuth(usuario.user.uid);
      nextPage();
    });
  }

  @action
  validateErrorsLogin(String code) {
    if (code == 'invalid-email') {
      return 'Email inv??lido, verifique os dados digitados.';
    } else if (code == 'user-not-found') {
      return 'Usu??rio n??o encontrado.';
    } else if (code == 'wrong-password') {
      return 'Senha incorreta, verifique os dados digitados.';
    }
    return 'Ocorreu um erro inesperado, solicite administrador.';
  }

  @action
  save(Function message, Function nextPage) async {
    try {
      utils.iniciarLoding();
      await saveMatricula();
      await savePerson();
      await saveStudent();
      await createLogin(senha, nextPage);

      utils.encerrarLoading();
      message('Cadastro realizado com sucesso');
    } catch (e) {
      utils.encerrarLoading();
      message('Ocorreu um erro, tente novamente');
    }
  }

  @action
  loginStudent() {}

  saveUser(String authId) async {
    usuario.setTipoUsuario('aluno');
    usuario.setAuthUid(authId);
    await FirebaseFirestore.instance.collection('usuario').add(usuario.toMap());
  }

  @action
  saveMatricula() async {
    matricula.setStatus('em_andamento');
    await FirebaseFirestore.instance
        .collection('matricula')
        .add(matricula.toMap());
  }

  @action
  savePerson() async {
    pessoa.setDataCadastro(Timestamp.now());
    await FirebaseFirestore.instance
        .collection('pessoa')
        .add(pessoa.toMap())
        .then((value) {
      student.setPessoaUid(value.id);
      usuario.setPessoaUid(pessoa.uid);
    });
  }

  @action
  saveStudent() async {
    await FirebaseFirestore.instance.collection('aluno').add(student.toMap());
  }
}
