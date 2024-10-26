import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:roate_text_tool2/services/serverces_1/shell_process.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:math';
import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../widget/normal/notify/show_notify.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel {
  Queue<FileSystemEntity> fileQueue = Queue();
  BuildContext context;

  List<FileStatus> fileStatuses = [];
  double progressValue = 0.0;
  bool _showFiles = false;
  String? _selectedDirectory;
  List<FileSystemEntity>? _files;
  bool get showFiles => _showFiles;
  String processingStatus = '';
  bool showDeleteButton = false;
  static bool _isCancelled = false;
  String? currentFilePath;
  String data = '';
  int get totalFiles => _files?.length ?? 0;
  String? currentProcessingFileName;
  ShellProcess shellProcess = ShellProcess();
  int completedFiles = 0;
  List<String> logMessages = [];

  String? get selectedDirectory => _selectedDirectory;
  List<FileSystemEntity>? get files => _files;

  final _dialogService = locator<DialogService>();
  int? _selectedFileCount = 1; // Biến để lưu số lượng tệp đã chọn

  int? get selectedFileCount => _selectedFileCount;
  late Semaphore semaphore;

  HomeViewModel(this.context) {
    semaphore = Semaphore(_selectedFileCount!);
  }

  void setSelectedFileCount(int? value) {
    _selectedFileCount = value;
    semaphore = Semaphore(_selectedFileCount!);
    notifyListeners(); // Thông báo cho UI rằng có sự thay đổi
  }

  void removeFile(int index) {
    files?.removeAt(index);
    notifyListeners();
  }

  Future<void> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      _selectedDirectory = selectedDirectory;
      _files = _getFilesFromDirectory(Directory(selectedDirectory));
      fileStatuses = List.generate(_files!.length,
          (index) => FileStatus(id: index, status: FileStatusType.idle));
      _showFiles = false; // Ẩn danh sách file
      notifyListeners();
    }
  }

  List<FileSystemEntity> _getFilesFromDirectory(Directory directory) {
    List<FileSystemEntity> files = [];
    try {
      directory.listSync(recursive: true).forEach((file) {
        if (file is File && _isValidFileType(file)) {
          files.add(file);
        }
      });
    } catch (e) {
      print('Error reading directory: $e');
    }
    return files;
  }

  bool _isValidFileType(File file) {
    final extension = file.uri.pathSegments.last.split('.').last.toLowerCase();
    return extension == 'pdf' || _isImageExtension(extension);
  }

  bool _isImageExtension(String extension) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff'];
    return imageExtensions.contains(extension);
  }

  String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    final fileSize = bytes / pow(1024, i);
    final formattedSize = fileSize.toStringAsFixed(2);

    return '$formattedSize ${units[i]}';
  }

  bool isFileLarge(int bytes) {
    const tenMB = 10 * 1024 * 1024; // 10 MB in bytes
    return bytes > tenMB;
  }

  void toggleFilesVisibility() {
    _showFiles = !_showFiles;
    notifyListeners();
  }

  String _outputDirectory = "";
  String get outputDirectory => _outputDirectory;

  Future<void> pickOutputDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      _outputDirectory = result;
      notifyListeners();
    }
  }

  Future<void> rotateFiles() async {
    if (_outputDirectory.isEmpty) {
      print('Nơi lưu trống');
      showNotify(context, titleText: "Vui lòng chọn nơi lưu", success: false);
      return;
    }

    logMessages = [];
    completedFiles = 0;
    int totalFiles = _files!.length;
    progressValue = 0.0;

    for (int i = 0; i < totalFiles; i++) {
      fileStatuses[i].status = FileStatusType.loading;
    }
    notifyListeners();

    // Thêm tất cả các file vào queue
    fileQueue.addAll(_files!);
    await ShellProcess.getPathToExe();

    // Bắt đầu chạy .exe trong một Isolate
    await _runExecutableInIsolate(shellProcess);
    await Future.delayed(Duration(seconds: 2));

    // Bắt đầu upload với số lượng file đồng thời giới hạn
    await _startNextUploadTask(totalFiles);
  }


  Future<void> _startNextUploadTask(int totalFiles) async {
    if (fileQueue.isEmpty) return;

    final FileSystemEntity file = fileQueue.removeFirst();
    final int index = _files!.indexOf(file);
    currentProcessingFileName = path.basename(file.path);

    // Chạy task upload
    await _uploadFileWithIsolate(file, index, totalFiles);
  }

  Future<void> _uploadFileWithIsolate(
      FileSystemEntity file, int index, int totalFiles) async {
    await semaphore.acquire(); // Acquire semaphore trước khi chạy task

    final receivePort = ReceivePort();
    await Isolate.spawn(
        _uploadIsolateEntryPoint, [file.path, receivePort.sendPort]);
    print('Bắt đầu xử lý file: $file tại thời điểm: ${DateTime.now()}');

    receivePort.listen((message) async {
      if (message is Map) {
        if (message.containsKey('progress')) {
          fileStatuses[index].progress = message['progress'];
          // Cập nhật UI theo tần suất giảm
          if (index % 10 == 0) notifyListeners();
        } else if (message.containsKey('status')) {
          if (message['status'] == 'done') {
            // Lưu file vào _outputDirectory
            await _saveFileToOutputDirectory(file);
            fileStatuses[index].status = FileStatusType.done;
            completedFiles++;
            progressValue = (completedFiles / totalFiles).clamp(0.0, 1.0);
            showDeleteButton = true;
            notifyListeners();
          } else if (message['status'] == 'failed') {
            fileStatuses[index].status = FileStatusType.idle;
            notifyListeners(); // Cập nhật UI khi có lỗi
          }
          // Giải phóng semaphore và chạy task tiếp theo
          semaphore.release();
          _startNextUploadTask(totalFiles);
        }
      }
    }).onDone(() {
      semaphore.release(); // Giải phóng semaphore khi lắng nghe hoàn tất
    });
  }

  Future<void> _runExecutableInIsolate(ShellProcess shellProcess) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
        _runExecutableIsolateEntryPoint, [receivePort.sendPort, shellProcess]);

    receivePort.listen((message) {
      if (message is String) {
        print('Executable Output: $message');
      }
    });
  }

  static void _runExecutableIsolateEntryPoint(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final ShellProcess shellProcess = args[1];
     ShellProcess.getPathToExe() ;
    try {
      // Sử dụng ShellProcess để mở executable
      await shellProcess.openExeAiProcess(openNow: true);
      sendPort.send('Executable đã được khởi động.');
    } catch (e) {
      sendPort.send('Đã xảy ra lỗi khi chạy executable: $e');
    }
  }

  Future<void> _saveFileToOutputDirectory(FileSystemEntity file) async {
    // Lưu file vào _outputDirectory
    try {
      String fileName = path.basename(file.path);
      String destinationPath = path.join(_outputDirectory, fileName);
      // Thực hiện yêu cầu upload file và nhận tệp PDF đã xử lý từ server
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8001/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath('input', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        // Nhận dữ liệu từ server
        final List<int> pdfBytes =
            await http.ByteStream(response.stream).toBytes();
        // Lưu tệp PDF vào đường dẫn chỉ định
        await File(destinationPath).writeAsBytes(pdfBytes);
        logMessages.add('File đã được lưu vào: $destinationPath');
      } else {
        print('Lỗi khi upload file: ${response.statusCode}');
        logMessages.add('Lỗi khi upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lưu file: $e');
    }
  }

  static void _uploadIsolateEntryPoint(List<dynamic> args) async {
    final filePath = args[0] as String; // filePath
    final sendPort = args[1] as SendPort; // SendPort

    try {
      // Tạo yêu cầu upload file
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8001/predict'),
      );

      request.files.add(await http.MultipartFile.fromPath('input', filePath));
      var response = await request.send();

      if (response.statusCode == 200) {
        sendPort.send({'progress': 1.0});
        sendPort.send({'status': 'done'});
      } else {
        final responseBody = await response.stream.bytesToString();
        print(
            'File upload failed with status: ${response.statusCode}, body: $responseBody');
        sendPort.send({'status': 'failed', 'error': responseBody});
      }
    } catch (e) {
      print('Lỗi khi upload file: $e');
      sendPort.send({'status': 'failed'});
    }
  }

  static List<Process> runningProcesses = [];

  void clearAll() {
    _isCancelled = true; // Đặt cờ hủy bỏ để dừng các nhiệm vụ đang chạy

    _files?.clear();
    fileStatuses.clear();
    _selectedDirectory = null;

    for (var process in runningProcesses) {
      Process.run('taskkill', ['/F', '/T', '/PID', process.pid.toString()]);
    }

    _outputDirectory = '';
    processingStatus = '';
    progressValue = 0.0;
    _selectedDirectory = '';
    showDeleteButton = false;

    notifyListeners(); // Cập nhật trạng thái giao diện
  }

  void resetProgress(int index) {
    if (index < 0 || index >= fileStatuses.length) return;

    fileStatuses[index].progress = 0.0; // Đặt lại tiến trình cho file
    notifyListeners(); // Cập nhật trạng thái giao diện
  }

  Future<void> openDialogResult(int index) async {
    try {
      // Lấy đường dẫn tệp từ chỉ số index
      final fileName = files?[index].path.split('/').last.split('\\').last;
      final outputFilePath = '$_outputDirectory\\$fileName';
      final fileNameNPro = files?[index].path;

      // Gọi phương thức showCustomDialog để hiển thị dialog
      final DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.resultTurn, // Thay đổi loại dialog nếu cần
        title: 'Ket Qua', // Tiêu đề của dialog
        data: {
          'filePath': outputFilePath,
          'fileNameNPro': fileNameNPro
        }, // Truyền đường dẫn tệp vào dialog
      );

      if (response == true) {
        print("thanh cong");
      } else {
        print("gg");
      }

      // Kiểm tra phản hồi từ dialog
    } catch (e) {
      print('Error handling result dialog: $e');
      // Xử lý lỗi nếu cần
    }
  }
}

class FileStatus {
  final int id;
  FileStatusType status;
  double progress; // Thêm thuộc tính tiến trình

  FileStatus({required this.id, required this.status, this.progress = 0.0});
}

enum FileStatusType { idle, loading, done }

class Semaphore {
  final int maxConcurrent;
  int _currentCount = 0;
  final List<Completer<void>> _waiting = []; // Danh sách các Completer đang chờ

  Semaphore(this.maxConcurrent);

  Future<void> acquire() async {
    if (_currentCount >= maxConcurrent) {
      final completer = Completer<void>();
      _waiting.add(completer);
      await completer.future;
    }
    _currentCount++;
  }

  void release() {
    _currentCount--;
    if (_waiting.isNotEmpty) {
      final completer = _waiting.removeAt(0);
      completer.complete();
    }
  }
}
