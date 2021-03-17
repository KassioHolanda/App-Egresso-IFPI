import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final authService = AuthService();

  @action
  loginComEmail(String email, String password) async {
    return authService.loginWithMail(email, password);
  }

  @action
  createLogin() async {
    // authService.createLoginWithMail("kassioleodido@gmail", senha);
  }
}
