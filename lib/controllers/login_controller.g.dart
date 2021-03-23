// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginController on _LoginControllerBase, Store {
  final _$loadingAtom = Atom(name: '_LoginControllerBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$loginComEmailAsyncAction =
      AsyncAction('_LoginControllerBase.loginComEmail');

  @override
  Future loginComEmail(
      String email, String password, Function message, Function action) {
    return _$loginComEmailAsyncAction
        .run(() => super.loginComEmail(email, password, message, action));
  }

  final _$recoverDataUserAsyncAction =
      AsyncAction('_LoginControllerBase.recoverDataUser');

  @override
  Future recoverDataUser() {
    return _$recoverDataUserAsyncAction.run(() => super.recoverDataUser());
  }

  final _$createLoginAsyncAction =
      AsyncAction('_LoginControllerBase.createLogin');

  @override
  Future createLogin() {
    return _$createLoginAsyncAction.run(() => super.createLogin());
  }

  final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase');

  @override
  dynamic validateErrorsLogin(String code) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.validateErrorsLogin');
    try {
      return super.validateErrorsLogin(code);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
