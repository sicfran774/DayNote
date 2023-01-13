import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

class ImportImages {
  static Future<String?> openGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}
