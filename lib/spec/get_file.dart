import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GetFile {
  static String appDir = "";
  static Future getFile(String date, String type) async {
    String extension = (type == 'photo') ? 'png' : 'json';
    if (await exists(date, type)) {
      File file = File('$appDir/${type}s/$date.$extension');
      return file;
    }
    return null;
  }

  static bool exists(String date, String type) {
    String extension = (type == 'photo') ? 'png' : 'json';
    return File('$appDir/${type}s/$date.$extension').existsSync();
  }

  static String path(String date, String type) {
    String extension = (type == 'photo') ? 'png' : 'json';
    return '$appDir/${type}s/$date.$extension';
  }

  static Future generateDirectories() async {
    appDir = (await getApplicationDocumentsDirectory()).path;
    if (!await File('$appDir/photos').exists()) {
      Directory('$appDir/photos').create();
    }
    if (!await File('$appDir/notes').exists()) {
      Directory('$appDir/notes').create();
    }
  }
}
