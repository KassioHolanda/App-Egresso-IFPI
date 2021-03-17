// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_utils.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoadingUtils on _LoadingUtilsBase, Store {
  final _$loadingAtom = Atom(name: '_LoadingUtilsBase.loading');

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

  final _$_LoadingUtilsBaseActionController =
      ActionController(name: '_LoadingUtilsBase');

  @override
  dynamic iniciarLoding() {
    final _$actionInfo = _$_LoadingUtilsBaseActionController.startAction(
        name: '_LoadingUtilsBase.iniciarLoding');
    try {
      return super.iniciarLoding();
    } finally {
      _$_LoadingUtilsBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic encerrarLoading() {
    final _$actionInfo = _$_LoadingUtilsBaseActionController.startAction(
        name: '_LoadingUtilsBase.encerrarLoading');
    try {
      return super.encerrarLoading();
    } finally {
      _$_LoadingUtilsBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
