import 'package:flutter/material.dart';
import 'package:roate_text_tool2/ui/common/ui_helpers.dart';
import 'package:roate_text_tool2/ui/widget/normal/text_model.dart';

class FileCountDropdown extends StatelessWidget {
  final int? selectedValue; // Giá trị đã chọn
  final ValueChanged<int?> onChanged; // Hàm callback khi giá trị thay đổi
  final double width; // Chiều rộng của dropdown
  final List<int> fileCountList; // Danh sách số lượng file

  const FileCountDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.fileCountList, // Nhận danh sách số lượng file từ bên ngoài
    this.width = 50, // Giá trị mặc định cho chiều rộng
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) /
          10, // Đặt chiều rộng cho container bao quanh Dropdown
      child: DropdownButtonFormField<int>(
        value: selectedValue,
        hint: Text(
          'Select number',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12), // Giảm kích thước font
        ), // Căn giữa hint
        onChanged: onChanged, // Gọi hàm callback khi giá trị thay đổi
        items: fileCountList // Sử dụng danh sách fileCountList
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Align(
              alignment: Alignment.center, // Căn giữa giá trị trong dropdown
              child: ClassText.normal(
                text: value.toString(),
              ),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(), // Đường viền cho dropdown
          filled: false, // Không tô màu nền
          contentPadding: EdgeInsets.symmetric(
            vertical: 5, // Giảm padding bên trên và bên dưới
            horizontal: 5, // Giảm padding bên trái và bên phải
          ), // Padding bên trong
        ),
        isExpanded:
            true, // Đảm bảo dropdown chiếm toàn bộ chiều rộng của container
      ),
    );
  }
}
