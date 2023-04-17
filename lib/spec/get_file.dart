import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class GetFile {
  static String appDir = "";
  static String defaultString = "";
  static String errorString = "";
  static Future getFile(String date, String type, {int index = 0}) async {
    String extension = (type == 'photo') ? 'png' : 'json';
    if (exists(date, type, index: index)) {
      File file = File('$appDir/${type}s/$date/$index.$extension');
      return file;
    }
    return null;
  }

  static bool exists(String date, String type, {int index = 0}) {
    String extension = (type == 'photo') ? 'png' : 'json';
    return File('$appDir/${type}s/$date/$index.$extension').existsSync();
  }

  static String path(String date, String type, {int index = 0}) {
    String extension = (type == 'photo') ? 'png' : 'json';
    return '$appDir/${type}s/$date/$index.$extension';
  }

  static Future generateDirectories() async {
    appDir = (await getApplicationDocumentsDirectory()).path;
    if (!await File('$appDir/photos').exists()) {
      Directory('$appDir/photos').create();
    }
    if (!await File('$appDir/notes').exists()) {
      Directory('$appDir/notes').create();
    }
    if (!await File('$appDir/album.json').exists()) {
      File('$appDir/album.json').create();
    }
    defaultString = await rootBundle.loadString("assets/json/default.json");
    errorString = await rootBundle.loadString("assets/json/error.json");
  }

  static File? loadAlbums() {
    return File('$appDir/album.json');
  }

  static Future generateNewDay(String date) async {
    if (!await File('$appDir/photos/$date').exists()) {
      Directory('$appDir/photos/$date').create();
      Directory('$appDir/notes/$date').create();
    }
  }

  static void deleteAllData() {
    File('$appDir/photos').delete(recursive: true);
    File('$appDir/notes').delete(recursive: true);
    File('$appDir/album.json').delete(recursive: true);
    generateDirectories();
  }
}
