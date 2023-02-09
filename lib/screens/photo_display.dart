import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoDisplay extends StatefulWidget {
  final AssetImage assetImage;
  final String date;
  const PhotoDisplay({super.key, required this.date, required this.assetImage});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  late AssetImage assetImage = widget.assetImage;
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
              onPressed: () => getPhoto(ImageSource.gallery),
            )),
        body: imageWidget());
  }

  Widget imageWidget() {
    if (displayImage != null) {
      uploadImage(displayImage);
      return Image.file(File(displayImage!.path));
    } else {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: assetImage,
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
