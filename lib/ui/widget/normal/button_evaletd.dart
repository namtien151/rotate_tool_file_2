import 'package:flutter/material.dart';
import 'package:roate_text_tool2/ui/common/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed; // Hàm gọi lại khi nút được nhấn
  final String label; // Văn bản hiển thị trên nút
  final IconData icon; // Biểu tượng hiển thị trên nút
  final Color foregroundColor; // Màu sắc văn bản
  final Color backgroundColor; // Màu nền
  final double width; // Kích thước nút
  final double height; // Chiều cao nút

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.foregroundColor = Colors.black, // Màu sắc văn bản mặc định
    this.backgroundColor = kcPrimaryColor, // Màu nền mặc định
    this.width = 100, // Kích thước mặc định
    this.height = 40, // Chiều cao mặc định
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        shadowColor: Colors.black26,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Bo góc nếu cần
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(width: 8), // Khoảng cách giữa icon và văn bản
          Text(
            label,
            style: TextStyle(color: foregroundColor), // Sử dụng màu văn bản
          ),
        ],
      ),
    );
  }
}
