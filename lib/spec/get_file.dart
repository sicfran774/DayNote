import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class GetFile {
  static String appDir = "";
  static String defaultString = "";
  static Future getFile(String date, String type) async {
    String extension = (type == 'photo') ? 'png' : 'json';
    if (exists(date, type)) {
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
    defaultString = await rootBundle.loadString("assets/json/default.json");
  }
}
