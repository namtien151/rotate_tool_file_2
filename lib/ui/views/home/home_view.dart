import 'dart:io';

import 'package:flutter/material.dart';
import 'package:roate_text_tool2/ui/views/top_bar/top_bar_view.dart';
import 'package:roate_text_tool2/ui/widget/normal/button_evaletd.dart';
import 'package:roate_text_tool2/ui/widget/normal/text_model.dart';
import 'package:stacked/stacked.dart';
import 'package:roate_text_tool2/ui/common/ui_helpers.dart';
import 'package:path/path.dart' as path;
import '../../layout/top_bar/default_layout.dart';
import '../../widget/normal/dropdow.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
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
          Expanded(
            child: Row(
              children: [
                Container(
                  width: screenWidth(context) / 1.3,
                  child: SingleChildScrollView(
                    child: Container(
                      height: 870,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            viewModel.selectedDirectory != null
                                ? Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.45,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.2), // Shadow color
                                              offset: const Offset(
                                                  0, 4), // Shadow offset
                                              blurRadius:
                                                  8, // Shadow blur radius
                                              spreadRadius:
                                                  1, // Shadow spread radius
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          leading: const Icon(Icons.folder,
                                              color: Colors.amber),
                                          title: Text(
                                            viewModel.selectedDirectory!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // if (viewModel.showFiles)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.35,
                                          height: 600,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.black12,
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex:
                                                      5, // Điều chỉnh tỷ lệ phần bên trái
                                                  child:
                                                      viewModel.files != null &&
                                                              viewModel.files!
                                                                  .isNotEmpty
                                                          ? ListView.builder(
                                                              itemCount:
                                                                  viewModel
                                                                      .files!
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                FileSystemEntity
                                                                    file =
                                                                    viewModel
                                                                            .files![
                                                                        index];
                                                                FileStatusType
                                                                    status =
                                                                    viewModel
                                                                        .fileStatuses[
                                                                            index]
                                                                        .status;
                                                                double
                                                                    progress =
                                                                    viewModel
                                                                        .fileStatuses[
                                                                            index]
                                                                        .progress;

                                                                return InkWell(
                                                                  onTap: () => viewModel
                                                                      .openDialogResult(
                                                                          index),
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            10),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              9),
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.black26,
                                                                          offset: Offset(
                                                                              0,
                                                                              3),
                                                                          blurRadius:
                                                                              10,
                                                                          spreadRadius:
                                                                              0.5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        ListTile(
                                                                      title:
                                                                          Text(
                                                                        path.basename(
                                                                            file.path),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      subtitle:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          if (file
                                                                              is File)
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  viewModel.formatFileSize(File(file.path).lengthSync()),
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w300,
                                                                                  ),
                                                                                ),
                                                                                if (viewModel.isFileLarge(File(file.path).lengthSync()))
                                                                                  const Text(
                                                                                    'Lưu ý: File này sẽ xử lý chậm',
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w300,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                Text(
                                                                                  file.path,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          else
                                                                            Container(),
                                                                        ],
                                                                      ),
                                                                      trailing:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          status == FileStatusType.idle
                                                                              ? Image.asset('assets/image/close.png')
                                                                              : status == FileStatusType.loading
                                                                                  ? SizedBox(
                                                                                      width: 50,
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 100.0,
                                                                                            height: 100.0,
                                                                                            child: Center(
                                                                                              child: CircularProgressIndicator(
                                                                                                strokeWidth: 3.0,
                                                                                                color: Colors.green,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          // Center(
                                                                                          //   child: Text('${(progress).toStringAsFixed(1)}%'),
                                                                                          // ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : const Icon(
                                                                                      Icons.check_circle,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(Icons.delete, color: Colors.redAccent),
                                                                            onPressed:
                                                                                () {
                                                                              viewModel.removeFile(index);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : const Center(
                                                              child: Text(
                                                                'No files selected',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ),
                                                ),
                                                Expanded(
                                                  flex:
                                                      5, // Điều chỉnh tỷ lệ phần bên phải
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white70,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9),
                                                      // boxShadow: const [
                                                      //   BoxShadow(
                                                      //     color: Colors.black26,
                                                      //     offset: Offset(0, 3),
                                                      //     blurRadius: 10,
                                                      //     spreadRadius: 0.5,
                                                      //   ),
                                                      // ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Thông tin bổ sung:',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        ClassText.normal(
                                                          text:
                                                              'Số lượng tệp: ${viewModel.files?.length ?? 0}',
                                                        ),
                                                        ClassText.normal(
                                                          text: viewModel
                                                                      .currentProcessingFileName !=
                                                                  null
                                                              ? 'Đang xử lý file: ${viewModel.currentProcessingFileName}'
                                                              : 'Không có file nào đang được xử lý',
                                                        ),

                                                        const SizedBox(
                                                            height:
                                                                10), // Khoảng cách giữa phần text và danh sách log
                                                        Expanded(
                                                          // Dùng Expanded để ListView chiếm không gian còn lại
                                                          child:
                                                              ListView.builder(
                                                            itemCount: viewModel
                                                                .logMessages
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero, // Loại bỏ khoảng cách đệm mặc định
                                                                title: ClassText
                                                                    .normal(
                                                                  text: viewModel
                                                                          .logMessages[
                                                                      index],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text(
                                      'No folder selected',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                            const SizedBox(height: 5),
                            Container(
                              child: Text(
                                viewModel.processingStatus,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Stack(
                                alignment: Alignment
                                    .center, // Căn giữa các phần tử trong Stack
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: LinearProgressIndicator(
                                        value: viewModel.progressValue,
                                        backgroundColor: Colors.white70,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Text(
                                      'Processing... ${(viewModel.progressValue * 100).toStringAsFixed(0)}%', // Hiển thị phần trăm và chữ "Processing..."
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (viewModel.showDeleteButton)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8,
                                        height: 50,
                                        child: CustomElevatedButton(
                                          onPressed: () {
                                            viewModel
                                                .clearAll(); // Gọi phương thức clearAll khi nút được nhấn
                                          },
                                          label:
                                              'Xóa Tất Cả', // Nhãn hiển thị trên nút
                                          icon: Icons
                                              .delete, // Biểu tượng của nút
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5, // Kích thước chiều rộng tùy chỉnh
                                          height:
                                              75, // Kích thước chiều cao tùy chỉnh
                                          // Bạn có thể thêm các tham số khác nếu CustomElevatedButton hỗ trợ, chẳng hạn như màu sắc
                                          backgroundColor:
                                              Colors.white, // Màu nền cho nút
                                          foregroundColor: Colors
                                              .black26, // Màu văn bản và biểu tượng
                                          // Đường viền bo tròn
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.black,
                          width: 0.4,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          "ROATE PDF home",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ))),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.black,
                                width: 0.4,
                              ),
                            ),
                          ),
                        ),
                        // Biến để lưu số lượng tệp đã chọn

                        Container(
                          height: screenHeight(context) / 1.3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Expanded(
                                  // Sử dụng Expanded để chiếm không gian còn lại
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClassText.normal(text: 'Input:'),
                                        SizedBox(height: 10),
                                        if (viewModel.selectedDirectory != null)
                                          Container(
                                            child: Text(
                                              '${viewModel.selectedDirectory}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                              overflow: TextOverflow
                                                  .ellipsis, // Giới hạn văn bản nếu quá dài
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                15), // Khoảng cách giữa Text và nút
                                        CustomElevatedButton(
                                          onPressed: () async {
                                            await viewModel.pickFolder();
                                          },
                                          label: 'Choose Folder',
                                          icon: Icons.folder_open,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5, // Kích thước nút
                                        ),

                                        SizedBox(
                                            height:
                                                20), // Khoảng cách giữa các nút
                                        ClassText.normal(text: 'Output:'),
                                        SizedBox(
                                            height:
                                                10), // Khoảng cách giữa các nút
                                        Container(
                                          child: Text(
                                            viewModel.outputDirectory,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        CustomElevatedButton(
                                          onPressed:
                                              viewModel.pickOutputDirectory,
                                          label: 'Chọn Nơi Lưu',
                                          icon: Icons.file_download_outlined,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5, // Kích thước nút
                                        ),

                                        SizedBox(height: 15),
                                        ClassText.normal(
                                            text:
                                                'Number of files processed simultaneously:'),
                                        SizedBox(
                                            height:
                                                10), // Khoảng cách giữa text và Dropdown
                                        FileCountDropdown(
                                          selectedValue: viewModel
                                              .selectedFileCount, // Truyền giá trị đã chọn từ ViewModel
                                          onChanged: (newValue) {
                                            viewModel.setSelectedFileCount(
                                                newValue); // Cập nhật giá trị trong ViewModel
                                          },
                                          fileCountList: List.generate(
                                              viewModel.totalFiles,
                                              (index) => index + 1),
                                        ),
                                        SizedBox(
                                            height:
                                                10), // Khoảng cách giữa dropdown và button "Xoay"
                                      ],
                                    ),
                                  ),
                                ),
                                // Button "Xoay" nằm bên dưới
                                Container(
                                  child: CustomElevatedButton(
                                    onPressed: () async {
                                      await viewModel.rotateFiles();
                                      for (int i = 0;
                                          i < viewModel.fileStatuses.length;
                                          i++) {
                                        viewModel.resetProgress(i);
                                      }
                                    },
                                    label: 'Xoay',
                                    icon: Icons.rotate_right,
                                    width: MediaQuery.of(context).size.width /
                                        5, // Kích thước chiều rộng tùy chỉnh
                                    height:
                                        75, // Kích thước chiều cao tùy chỉnh
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel(context);
}
