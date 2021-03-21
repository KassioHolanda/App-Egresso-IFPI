import 'package:mobx/mobx.dart';
part 'drawer_controller.g.dart';

class DrawerPageController = _DrawerPageControllerBase with _$DrawerPageController;

abstract class _DrawerPageControllerBase with Store {
  @observable
  int numPage = 0;

  @action
  setNumPage(int numP) => numPage = numP;
}
