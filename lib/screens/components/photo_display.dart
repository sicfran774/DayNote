// ignore_for_file: avoid_print

import 'dart:io';
import 'package:day_note/screens/components/notes_section.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../spec/get_photo.dart';

String photoPath = '${GetPhoto.appDir}/photos';

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
    XFile? tempImage = await _picker.pickImage(source: source);

    if (tempImage == null) {
      return null;
    }

    if (await File('$photoPath/$date.png').exists()) {
      print('$date already exists, deleting');
      await File('$photoPath/$date.png').delete();
    } else {
      print('new image');
    }

    File newImage = await File(tempImage.path).copy('$photoPath/$date.png');

    setState(() {
      image = newImage;
    });

    print("Saved image to $photoPath/$date.png");
  }

  void deletePhoto() async {
    Navigator.pop(context);
    try {
      File('$photoPath/$date.png').delete();
    } catch (e) {}
    setState(() {
      image = null;
    });
  }

  void updatePath() async {
    photoPath = '${(await getApplicationDocumentsDirectory()).path}/photos';
  }

  @override
  Widget build(BuildContext context) {
    updatePath();
    return FutureBuilder(
        future: GetPhoto.getPhoto(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return screen(context, snapshot.data);
          } else {
            return Container(color: gitHubBlack);
          }
        });
  }

  Widget screen(BuildContext context, data) {
    PageController pageController = PageController();
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text(title!)),
        floatingActionButton: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: FloatingActionButton(
                child: const Icon(Icons.photo),
                onPressed: () => chooseImageWidget(context))),
        body: ListView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: [
            imageWidget(data),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 3, color: gitHubBlack),
                )),
                height: 500,
                child: NotesSection()),
          ],
        ));
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
      return Image(image: FileImage(image));
    } else {
      return const SizedBox(
        height: 500,
        child: Center(child: Text("No image found :(", style: headerMedium)),
      );
    }
  }

  void uploadImage(XFile? file) async {
    Reference? imagesRef = storageRef.child(date);
    try {
      await imagesRef.putFile(File(file!.path));
    } on FirebaseException catch (e) {}
  }
}
