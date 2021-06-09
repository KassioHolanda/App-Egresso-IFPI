// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginController on _LoginControllerBase, Store {
  final _$cursoSelectAtom = Atom(name: '_LoginControllerBase.cursoSelect');

  @override
  bool get cursoSelect {
    _$cursoSelectAtom.reportRead();
    return super.cursoSelect;
  }

  @override
  set cursoSelect(bool value) {
    _$cursoSelectAtom.reportWrite(value, super.cursoSelect, () {
      super.cursoSelect = value;
    });
  }

  final _$usuarioAtom = Atom(name: '_LoginControllerBase.usuario');

  @override
  Usuario get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(Usuario value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  final _$pessoaAtom = Atom(name: '_LoginControllerBase.pessoa');

  @override
  PessoaModel get pessoa {
    _$pessoaAtom.reportRead();
    return super.pessoa;
  }

  @override
  set pessoa(PessoaModel value) {
    _$pessoaAtom.reportWrite(value, super.pessoa, () {
      super.pessoa = value;
    });
  }

  final _$studentAtom = Atom(name: '_LoginControllerBase.student');

  @override
  StudentModel get student {
    _$studentAtom.reportRead();
    return super.student;
  }

  @override
  set student(StudentModel value) {
    _$studentAtom.reportWrite(value, super.student, () {
      super.student = value;
    });
  }

  final _$matriculaAtom = Atom(name: '_LoginControllerBase.matricula');

  @override
  MatriculaModel get matricula {
    _$matriculaAtom.reportRead();
    return super.matricula;
  }

  @override
  set matricula(MatriculaModel value) {
    _$matriculaAtom.reportWrite(value, super.matricula, () {
      super.matricula = value;
    });
  }

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

  final _$recuperarSenhaUsuarioAsyncAction =
      AsyncAction('_LoginControllerBase.recuperarSenhaUsuario');

  @override
  Future<dynamic> recuperarSenhaUsuario(String email) {
    return _$recuperarSenhaUsuarioAsyncAction
        .run(() => super.recuperarSenhaUsuario(email));
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
  Future createLogin(String password, Function nextPage) {
    return _$createLoginAsyncAction
        .run(() => super.createLogin(password, nextPage));
  }

  final _$saveAsyncAction = AsyncAction('_LoginControllerBase.save');

  @override
  Future save(Function message, Function nextPage, String password) {
    return _$saveAsyncAction.run(() => super.save(message, nextPage, password));
  }

  final _$saveMatriculaAsyncAction =
      AsyncAction('_LoginControllerBase.saveMatricula');

  @override
  Future saveMatricula() {
    return _$saveMatriculaAsyncAction.run(() => super.saveMatricula());
  }

  final _$savePersonAsyncAction =
      AsyncAction('_LoginControllerBase.savePerson');

  @override
  Future savePerson() {
    return _$savePersonAsyncAction.run(() => super.savePerson());
  }

  final _$saveStudentAsyncAction =
      AsyncAction('_LoginControllerBase.saveStudent');

  @override
  Future saveStudent() {
    return _$saveStudentAsyncAction.run(() => super.saveStudent());
  }

  final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase');

  @override
  dynamic setCursoSelect(dynamic value) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.setCursoSelect');
    try {
      return super.setCursoSelect(value);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

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
  dynamic loginStudent() {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.loginStudent');
    try {
      return super.loginStudent();
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cursoSelect: ${cursoSelect},
usuario: ${usuario},
pessoa: ${pessoa},
student: ${student},
matricula: ${matricula},
loading: ${loading}
    ''';
  }
}
