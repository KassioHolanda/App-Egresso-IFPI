import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:egresso_ifpi/utils/loading_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final authService = AuthService();
  final loadingUtils = LoadingUtils();

  @observable
  bool loading = false;

  @action
  loginComEmail(
      String email, String password, Function message, Function action) async {
    loadingUtils.iniciarLoding();

    await authService.loginWithMail(email, password).then((value) {
      loadingUtils.encerrarLoading();
      action();
    }).catchError((error) {
      loadingUtils.encerrarLoading();
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
