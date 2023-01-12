import 'package:flutter/material.dart';

import '../func/import_images.dart';

class PhotoDisplay extends StatelessWidget {
  final AssetImage assetImage;
  const PhotoDisplay({super.key, required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Image Preview')),
      // Temp image, must change into path of photo
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetImage,
            fit: BoxFit.contain,
          ),
        ),
      ),
      floatingActionButton: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: FloatingActionButton(
            child: const Icon(Icons.photo),
            onPressed: () => ImportImages.openGallery(),
          )),
    );
  }
}
