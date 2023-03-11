import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GetPhoto {
  static String appDir = "";
  static Future getPhoto(String date) async {
    if (await File('$appDir/photos/$date.png').exists()) {
      File file = File('$appDir/photos/$date.png');
      return file;
    }
    return null;
  }

  static Future generateDirectories() async {
    appDir = (await getApplicationDocumentsDirectory()).path;
    if (!await File('$appDir/photos').exists()) {
      Directory('$appDir/photos').create();
    }
  }
}
