import 'package:roate_text_tool2/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:roate_text_tool2/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:roate_text_tool2/ui/views/home/home_view.dart';
import 'package:roate_text_tool2/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:roate_text_tool2/ui/dialogs/result_turn/result_turn_dialog.dart';
import 'package:roate_text_tool2/ui/views/top_bar/top_bar_view.dart';
import 'package:roate_text_tool2/ui/views/rotate_tool/rotate_tool_view.dart';
import 'package:roate_text_tool2/ui/views/split_tool/split_tool_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: TopBarView),
    MaterialRoute(page: RotateToolView),
    MaterialRoute(page: SplitToolView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: ResultTurnDialog),
// @stacked-dialog
  ],
)
class App {}
