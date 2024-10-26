import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../common/ui_helpers.dart';
import '../top_bar/top_bar_view.dart';
import 'split_tool_viewmodel.dart';

class SplitToolView extends StackedView<SplitToolViewModel> {
  const SplitToolView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SplitToolViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
    body: Column(
      children: [
        SizedBox(
          height: 5,
        ),
        TopBarView(
          screenHeight: screenHeight(context),
          screenWidth: screenWidth(context),
        ),
      ],
    ),
    );
  }

  @override
  SplitToolViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SplitToolViewModel();
}
