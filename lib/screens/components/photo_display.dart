// ignore_for_file: avoid_print

import 'dart:io';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../spec/get_photo.dart';

class PhotoDisplay extends StatefulWidget {
  final File? image;
  final String date;
  final String? title;

  const PhotoDisplay({
    super.key,
    required this.date,
    required this.image,
    required this.title,
  });

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  late File? image = widget.image;
  late String date = widget.date;
  late String? title = widget.title;

  Future choosePhoto(ImageSource source) async {
    Navigator.pop(context);
    String path = (await getApplicationDocumentsDirectory()).path;
    XFile? tempImage = await _picker.pickImage(source: source);

    if (tempImage == null) {
      return null;
    }

    if (await File('$path/$date.png').exists()) {
      print('$date already exists, deleting');
      await File('$path/$date.png').delete();
    } else {
      print('new image');
    }

    File newImage = await File(tempImage.path).copy('$path/$date.png');

    setState(() {
      image = newImage;
    });

    print("Saved image to $path/$date.png");
  }

  void deletePhoto() async {
    Navigator.pop(context);
    String path = (await getApplicationDocumentsDirectory()).path;
    File('$path/$date.png').delete();
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetPhoto.getPhoto(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                backgroundColor: Colors.black,
                appBar: AppBar(title: Text(title!)),
                floatingActionButton: Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: FloatingActionButton(
                        child: const Icon(Icons.photo),
                        onPressed: () => chooseImageWidget(context))),
                body: imageWidget(snapshot.data));
          } else {
            return Container(color: gitHubBlack);
          }
        });
  }

  Future chooseImageWidget(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return optionsWidget();
      },
    );
  }

  Wrap optionsWidget() {
    if (image != null) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a photo'),
            onTap: () => choosePhoto(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from gallery'),
            onTap: () => choosePhoto(ImageSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete this image'),
            onTap: () => deletePhoto(),
          ),
        ],
      );
    } else {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a photo'),
            onTap: () => choosePhoto(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from gallery'),
            onTap: () => choosePhoto(ImageSource.gallery),
          ),
        ],
      );
    }
  }

  Widget imageWidget(File? image) {
    if (image != null) {
      this.image = image;
      //uploadImage(displayImage);
      return Center(child: Image.file(File(image.path)));
    } else {
      return const Center(
        child: SizedBox(
          child: Text("Nothing found...", style: headerMedium),
          // decoration: const BoxDecoration(
          // image: DecorationImage(
          // image: AssetImage('assets/images/saul.jpg'),
          // fit: BoxFit.contain,
        ),
      ); //));
    }
  }

  void uploadImage(XFile? file) async {
    Reference? imagesRef = storageRef.child(date);
    try {
      await imagesRef.putFile(File(file!.path));
    } on FirebaseException catch (e) {}
  }
}
