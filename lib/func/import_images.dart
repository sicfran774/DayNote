import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

class ImportImages {
  static void test() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }
}
