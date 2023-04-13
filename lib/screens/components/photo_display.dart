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

  Future amountOfDayNotes() async {
    final photoDir = Directory('${GetFile.appDir}/photos/$date');
    final noteDir = Directory('${GetFile.appDir}/notes/$date');
    List<FileSystemEntity> photos;
    List<FileSystemEntity> notes;
    try {
      photos = await photoDir.list().toList();
      notes = await noteDir.list().toList();
    } catch (e) {
      return 1;
    }

    if (photos.isEmpty) {
      return 1;
    }

    for (var photo in photos) {
      try {
        photo.renameSync(GetFile.path(date, 'photo'));
      } catch (e) {
        continue;
      }
    }

    if (notes.isNotEmpty) {
      for (var note in notes) {
        try {
          note.renameSync(GetFile.path(date, 'note'));
        } catch (e) {
          continue;
        }
      }
    }

    print(photos);
    return photos.length + 1;
  }

  void renameDayNotes() {}

  Future choosePhoto(ImageSource source, int index) async {
    Navigator.pop(context);
    XFile? tempImage = await _picker.pickImage(source: source);

    if (tempImage == null) {
      return null;
    }

    if (GetFile.exists(date, 'photo', index: index)) {
      print('$date already exists, deleting');
      await File('$photoPath/$date/$index.png').delete();
    }

    File newImage =
        await File(tempImage.path).copy('$photoPath/$date/$index.png');

    setState(() {
      image = newImage;
    });

    print("Saved image to $photoPath/$date/$index.png");
  }

  void deleteDayNote(int index) async {
    if (GetFile.exists(date, 'photo')) {
      File('$photoPath/$date/$index.png').delete();
    }
    if (GetFile.exists(date, 'note')) {
      File('$notePath/$date/$index.json').delete();
    }
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController horizontalController = PageController();
    GetFile.generateNewDay(date);
    return FutureBuilder(
        future: amountOfDayNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(title: Text(title!)),
                body: PageView.builder(
                  controller: horizontalController,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: GetFile.getFile(date, 'photo', index: index),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            image = snapshot.data;
                            return individualDayNote(snapshot.data, index);
                          } else {
                            return Container(color: gitHubBlack);
                          }
                        });
                  },
                  itemCount: snapshot.data,
                ));
          } else {
            return Container();
          }
        });
  }

  PageView individualDayNote(data, int index) {
    PageController verticalController = PageController();
    return PageView(
      controller: verticalController,
      scrollDirection: Axis.vertical,
      children: [
        if (image == null) ...[
          photoSection(data, index),
        ] else ...[
          photoSection(data, index),
          NotesSection(date: date, index: index),
        ]
      ],
    );
  }

  Scaffold photoSection(data, index) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.photo),
          onPressed: () => chooseImageWidget(context, index)),
      body: Center(child: imageWidget(data)),
    );
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

  Future chooseImageWidget(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return optionsWidget(index);
      },
    );
  }

  Wrap optionsWidget(int index) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_camera),
          title: const Text('Take a photo'),
          onTap: () => choosePhoto(ImageSource.camera, index),
        ),
        ListTile(
          leading: const Icon(Icons.photo),
          title: const Text('Choose from gallery'),
          onTap: () => choosePhoto(ImageSource.gallery, index),
        ),
        if (image != null) ...[
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete this day note'),
            onTap: () => confirmDelete(context, index),
          ),
        ]
      ],
    );
  }

  confirmDelete(BuildContext context, int index) {
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget confirm = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          deleteDayNote(index);
        },
        child: const Text("Yes"));

    AlertDialog confirmation = AlertDialog(
      title: const Text("Delete Day Note"),
      content:
          const Text("Are you sure you want to delete this photo and note?"),
      actions: [cancel, confirm],
    );

    showDialog(
        context: context, builder: (BuildContext context) => confirmation);
  }

  /* Firebase */

  void uploadImage(XFile? file) async {
    Reference? imagesRef = storageRef.child(date);
    try {
      await imagesRef.putFile(File(file!.path));
    } on FirebaseException catch (e) {}
  }
}
