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
  loginComEmail(String email, String password) async {
    loadingUtils.iniciarLoding();
    final UserCredential auth = await authService.loginWithMail(email, password);
    loadingUtils.encerrarLoading();
    return auth;
  }

  @action
  createLogin() async {
    // authService.createLoginWithMail("kassioleodido@gmail", senha);
  }
}
