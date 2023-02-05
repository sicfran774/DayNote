import 'dart:io';
import 'package:flutter/material.dart';
import '../func/import_images.dart';

class PhotoDisplay extends StatefulWidget {
  final AssetImage assetImage;
  const PhotoDisplay({super.key, required this.assetImage});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  late AssetImage assetImage = widget.assetImage;
  late String _path = "";

  void changePhoto() {
    setState(() {
      ImportImages.openGallery().then((newPath) {
        _path = newPath;
      });
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
              onPressed: () => changePhoto(),
            )),
        body: work());
  }

  Widget work() {
    return SafeArea(
      child: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} has occurred',
              ),
            );
          } else if (snapshot.hasData) {
            return Image.file(File(_path));
          }
        }
        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
          image: assetImage,
          fit: BoxFit.contain,
        )));
      }),
    );
  }
}
