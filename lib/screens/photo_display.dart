import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoDisplay extends StatefulWidget {
  final AssetImage assetImage;
  const PhotoDisplay({super.key, required this.assetImage});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final ImagePicker _picker = ImagePicker();
  late AssetImage assetImage = widget.assetImage;
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
        body: work());
  }

  Widget work() {
    return Container(
        child: displayImage != null
            ? Image.file(File(displayImage!.path))
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                image: assetImage,
                fit: BoxFit.contain,
              ))));
  }
}
