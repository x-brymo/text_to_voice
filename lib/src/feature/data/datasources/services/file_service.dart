// services/file_service.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class FileService {
  final Uuid _uuid = const Uuid();

  Future<File?> pickTextFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      
      if (result != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking text file: $e');
      return null;
    }
  }

  Future<File?> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav'],
      );
      
      if (result != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking audio file: $e');
      return null;
    }
  }

  Future<String> readTextFile(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      print('Error reading text file: $e');
      return '';
    }
  }

  Future<String> saveTextToFile(String text) async {
    try {
      final String fileName = '${_uuid.v4()}.txt';
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDocDir.path}/texts/$fileName';
      
      // Ensure directory exists
      final Directory directory = Directory('${appDocDir.path}/texts');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      
      // Write text to file
      final File file = File(filePath);
      await file.writeAsString(text);
      
      return filePath;
    } catch (e) {
      print('Error saving text: $e');
      rethrow;
    }
  }

  Future<void> shareFile(String filePath, {String? text}) async {
    try {
      if (text != null) {
        await Share.shareXFiles([XFile(filePath)], text: text);
      } else {
        await Share.shareXFiles([XFile(filePath)]);
      }
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
}