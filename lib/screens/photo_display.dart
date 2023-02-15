import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoDisplay extends StatefulWidget {
  final File? image;
  final String date;
  const PhotoDisplay({super.key, required this.date, required this.image});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  late File? image = widget.image;
  late String date = widget.date;
  XFile? displayImage;

  Future getPhoto(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);

    setState(() {
      displayImage = image;
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
    if (displayImage != null) {
      //uploadImage(displayImage);
      return Image.file(File(displayImage!.path));
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
