import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class TopBarViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();

  List<TopBarModel> listTopBarModel = [
    TopBarModel(
        id: 0,
        title: 'ROATE PDF',
        routes: Routes.rotateToolView,
        listRoutes: [Routes.rotateToolView]),
    TopBarModel(id: 1, title: 'SPLIT PDF', routes: Routes.splitToolView, listRoutes: [Routes.splitToolView]),
    TopBarModel(
        id: 2, title: 'COMPRESS PDF', routes: '/compress', listRoutes: []),
    TopBarModel(
        id: 3, title: 'CONVERT PDF', routes: '/convert', listRoutes: []),
    TopBarModel(
        id: 4, title: 'ALL PDF TOOLS', routes: '/alltools', listRoutes: []),
  ];
  int indexSelected = 0;
  void runStartUp() async {
    setBusy(true);
    for (TopBarModel item in listTopBarModel) {
      for (String route in item.listRoutes) {
        if (route == navigationService.currentRoute) {
          indexSelected = item.id;
          notifyListeners(); // Thông báo cho UI cập nhật
        }
      }
    }
    setBusy(false);
  }

  void navigationRoute(String routes) {
    if (navigationService.currentRoute != routes) {
      // Tìm ID tương ứng với route được chọn
      for (TopBarModel item in listTopBarModel) {
        if (item.routes == routes) {
          indexSelected = item.id; // Cập nhật indexSelected
          break;
        }
      }
      navigationService.clearStackAndShow(routes);
      notifyListeners(); // Thông báo cho UI cập nhật
    }
  }
}

class TopBarModel {
  int id;
  String title;
  List<String> listRoutes;
  String routes;
  TopBarModel({
    required this.id,
    required this.title,
    required this.listRoutes,
    required this.routes,
  });
}
