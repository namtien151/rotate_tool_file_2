import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:path/path.dart' as path;
import 'package:roate_text_tool2/api/base_api.dart';

class ShellProcess {
  final Shell shell = Shell(runInShell: true);
  final String processName = "rotate_file.exe"; // Đổi tên file nếu cần
  static late String pathToExe;

  // Hàm để lấy đường dẫn đến file .exe
  static Future<void> getPathToExe() async {
    // Đường dẫn cụ thể tới file .exe
    pathToExe =
    "C:\\Users\\tntie\\output\\rotate_file_4\\rotate_file.exe";
    // "G:\\VSCODE\\flutter\\to-do-list\\roate_text_tool2\\lib\\services\\rotate_file\\rotate_file.exe";

    print("Path to exe: $pathToExe");
  }

  Future<bool> checkPortExists() async {
    try {
      var result = await shell.run('netstat -an | findstr ":${BaseApi.portApi}"');

      if (result.outText.isNotEmpty) {
        String notify = result.outText;
        bool match = RegExp(r'(LISTENING)').hasMatch(notify);
        if (match) {
          return true; // Cổng đang được sử dụng
        } else {
          await stopExeFile();
          return false;
        }
      } else {
        return false; // Cổng không được sử dụng
      }
    } catch (e) {
      print('Error checking port: $e');
      return false; // Nếu có lỗi, giả định cổng không được sử dụng
    }
  }

  // Mở process EXE
  Future<void> openExeAiProcess({bool? openNow}) async {
    await getPathToExe(); // Đảm bảo rằng đường dẫn đã được lấy

    // bool checkExistPort = await checkPortExists();
    if (openNow == true) {
      try {
        // Chạy file exe mà không hiển thị cửa sổ CMD
        await Process.start(pathToExe, [],
            mode: ProcessStartMode.detached);
        print("Server đã được khởi động với kết quả: ");
      } catch (e) {
        print("Có lỗi xảy ra khi mở exe: $e");
      }
    } else {
      print("Server đã chạy trên cổng này.");
    }
  }

  // Dừng process EXE
  Future<void> stopExeFile() async {
    try {
      // Dừng rotate_file.exe
      var result = await shell.run('tasklist /FI "IMAGENAME eq $processName" /FO CSV /NH');
      if (result.outText.isNotEmpty) {
        var lines = result.outText.split('\n');
        if (lines.isNotEmpty && !lines.first.contains('No tasks')) {
          var pid = lines.first.split(',')[1].replaceAll('"', '').trim();
          await shell.run('taskkill /PID $pid /F /T');
          print('rotate_file.exe stopped successfully.');
        }
      }

      // Dừng tất cả các tiến trình pdfinfo.exe
      await shell.run('taskkill /F /IM pdfinfo.exe /T');
      print('All pdfinfo.exe processes stopped.');

      // Thêm thời gian chờ để hệ thống giải phóng tài nguyên
      await Future.delayed(Duration(seconds: 1));

    } catch (e) {
      print('Error stopping exe files: $e');
    }
  }

}