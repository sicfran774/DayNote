// ignore_for_file: avoid_print

import 'dart:io';
import 'package:day_note/screens/components/notes_section.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../spec/get_file.dart';

String photoPath = '${GetFile.appDir}/photos';
String notePath = '${GetFile.appDir}/notes';

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

    if (GetFile.exists(date, 'photo')) {
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

  void deleteDayNote() async {
    Navigator.pop(context);
    if (GetFile.exists(date, 'photo')) {
      File('$photoPath/$date.png').delete();
    }
    if (GetFile.exists(date, 'note')) {
      File('$notePath/$date.json').delete();
    }
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetFile.getFile(date, 'photo'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            image = snapshot.data;
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
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: [
            if (image == null) ...[
              photoSection(data),
            ] else ...[
              photoSection(data),
              NotesSection(date: date),
            ]
          ],
        ));
  }

  Scaffold photoSection(data) {
    return Scaffold(
        body: Center(child: imageWidget(data)),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.photo),
            onPressed: () => chooseImageWidget(context)));
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
            title: const Text('Delete this day note'),
            onTap: () => deleteDayNote(),
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
