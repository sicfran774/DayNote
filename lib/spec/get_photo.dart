import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GetPhoto {
  static Future getPhoto(String date) async {
    final String appDir = (await getApplicationDocumentsDirectory()).path;
    if (await File('$appDir/$date.png').exists()) {
      File file = File('$appDir/$date.png');
      return file;
    }
    return null;
  }
}
