import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../widget/normal/button_model.dart';
import 'top_bar_viewmodel.dart';

class TopBarView extends StackedView<TopBarViewModel> {
  final double screenHeight;
  final double screenWidth;

  const TopBarView({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TopBarViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: screenHeight / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logoTC.svg', // Đường dẫn tới logo
            width: screenWidth * 0.15, // Điều chỉnh kích thước logo
            height: screenHeight / 7, // Điều chỉnh kích thước logo
            fit: BoxFit.contain, // Giữ tỉ lệ khi thay đổi kích thước
          ),
          Container(
            width: screenWidth / 1.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                viewModel.listTopBarModel.length,
                (index) {
                  TopBarModel item = viewModel.listTopBarModel[index];
                  bool selected = viewModel.indexSelected ==
                      item.id; // Kiểm tra nút hiện tại

                  return CustomButton(
                    text: item.title,
                    onPressed: () {
                      viewModel.navigationRoute(item.routes);
                    },
                    colorBackGround:
                        selected ? Colors.orange : Colors.transparent,

                    // Màu sắc dựa trên trạng thái
                    // Có thể thêm các tham số khác nếu cần
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  TopBarViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopBarViewModel();

  @override
  void onViewModelReady(TopBarViewModel viewModel) {
    viewModel.runStartUp();
    super.onViewModelReady(viewModel);
  }
}
