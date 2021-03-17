import 'package:mobx/mobx.dart';
part 'loading_utils.g.dart';

class LoadingUtils = _LoadingUtilsBase with _$LoadingUtils;

abstract class _LoadingUtilsBase with Store {
  @observable
  bool loading = false;

  @action
  iniciarLoding() {
    loading = true;
  }

  @action
  encerrarLoading() {
    loading = false;
  }
}
