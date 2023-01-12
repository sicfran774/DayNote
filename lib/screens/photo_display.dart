import 'package:flutter/material.dart';

import '../func/import_images.dart';

class PhotoDisplay extends StatelessWidget {
  final AssetImage assetImage;
  const PhotoDisplay({super.key, required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Image Preview')),
      // Temp image, must change into path of photo
      body: Center(
        child: Image(image: assetImage),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.photo),
              onPressed: () => ImportImages.openGallery(),
            ),
          ],
        ),
      ),
    );
  }
}
