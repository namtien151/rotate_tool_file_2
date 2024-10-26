import 'package:flutter/material.dart';
import 'package:roate_text_tool2/ui/widget/normal/text_model.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool showArrows;
  final Color colorBackGround;
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.showArrows = false,
    required this.colorBackGround,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          ClassText.normal(
              text: text), // Sử dụng ClassText.normal thay cho Text
          if (showArrows) ...[
            SizedBox(width: 8), // Khoảng cách giữa chữ và mũi tên
            Icon(Icons.arrow_drop_down),
          ],
        ],
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(colorBackGround),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.deepOrangeAccent;
            }
            return null;
          },
        ),
      ),
    );
  }
}
