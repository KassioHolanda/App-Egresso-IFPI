import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final authService = AuthService();
  final utils = GetIt.I.get<Utils>();

  @observable
  bool loading = false;

  @action
  loginComEmail(
      String email, String password, Function message, Function action) async {
    utils.iniciarLoding();

    await authService.loginWithMail(email, password).then((value) {
      utils.encerrarLoading();
      action();
    }).catchError((error) {
      utils.encerrarLoading();
      message(validateErrorsLogin(error.code));
    });
  }

  @action
  createLogin() async {
    // authService.createLoginWithMail("kassioleodido@gmail", senha);
  }

  @action
  validateErrorsLogin(String code) {
    if (code == 'invalid-email') {
      return 'Email inválido, verifique os dados digitados.';
    } else if (code == 'user-not-found') {
      return 'Usuário não encontrado.';
    } else if (code == 'wrong-password') {
      return 'Senha incorreta, verifique os dados digitados.';
    }
    return 'Ocorreu um erro inesperado, solicite administrador.';
  }
}
