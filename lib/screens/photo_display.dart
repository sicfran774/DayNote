import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoDisplay extends StatefulWidget {
  //final Function() notifyParent;
  final File? image;
  final String date;
  const PhotoDisplay({
    super.key,
    required this.date,
    required this.image,
  });
  //required this.notifyParent});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  late File? image = widget.image;
  late String date = widget.date;

  Future getPhoto(ImageSource source) async {
    XFile? tempImage = await _picker.pickImage(source: source);
    String path = (await getApplicationDocumentsDirectory()).path;
    if (File('$path/$date.png').existsSync()) {
      print('$date already exists, deleting');
      await File('$path/$date.png').delete();
    }
    File newImage = await File(tempImage!.path).copy('$path/$date.png');
    print("Saved image to $path/$date.png");

    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Image Preview')),
        floatingActionButton: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: FloatingActionButton(
                child: const Icon(Icons.photo),
                onPressed: () => chooseImageWidget(context))),
        body: imageWidget(image));
  }

  Future chooseImageWidget(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () => getPhoto(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from gallery'),
              onTap: () => getPhoto(ImageSource.gallery),
            ),
          ],
        );
      },
    );
  }

  Widget imageWidget(File? image) {
    if (image != null) {
      //uploadImage(displayImage);
      return Image.file(File(image.path));
    } else {
      return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
        image: AssetImage('assets/images/saul.jpg'),
        fit: BoxFit.contain,
      )));
    }
  }

  void uploadImage(XFile? file) async {
    Reference? imagesRef = storageRef.child(date);
    try {
      await imagesRef.putFile(File(file!.path));
    } on FirebaseException catch (e) {}
  }
}
