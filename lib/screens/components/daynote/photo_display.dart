// ignore_for_file: avoid_print

import 'dart:io';
import 'package:day_note/screens/components/daynote/notes_section.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../spec/get_file.dart';

String photoPath = '${GetFile.appDir}/photos';
String notePath = '${GetFile.appDir}/notes';

class PhotoDisplay extends StatefulWidget {
  final String date;
  final String? title;

  const PhotoDisplay({
    super.key,
    required this.date,
    required this.title,
  });

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  final storageRef = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();
  late String date = widget.date;
  late String? title = widget.title;

  int page = 0;

  Future directories(int index) async {
    final photoDir = Directory('${GetFile.appDir}/photos/$date');
    final noteDir = Directory('${GetFile.appDir}/notes/$date');
    List<FileSystemEntity> photos;
    List<FileSystemEntity> notes;
    try {
      photos = await photoDir.list().toList();
      notes = await noteDir.list().toList();
    } catch (e) {
      return [];
    }
    return (index == 0) ? photos : notes;
  }

  Future amountOfDayNotes() async {
    List<FileSystemEntity> photos = await directories(0); //get photo array

    if (photos.isEmpty) {
      return 1;
    }

    return photos.length + 1;
  }

  void renameDayNotes() async {
    List<FileSystemEntity> photos = await directories(0); //get photo array
    List<FileSystemEntity> notes = await directories(1); //get note array

    int index = 0;
    for (var photo in photos) {
      try {
        print(
            'renaming $photo to ${GetFile.path(date, 'photo', index: index)}');
        photo.rename(GetFile.path(date, 'photo', index: index));
        ++index;
      } catch (e) {
        continue;
      }
    }

    index = 0;
    if (notes.isNotEmpty) {
      for (var note in notes) {
        try {
          note.rename(GetFile.path(date, 'note', index: index));
          ++index;
        } catch (e) {
          continue;
        }
      }
    }
  }

  void deleteDayNote(int index) async {
    File('$photoPath/$date/$index.png').delete();

    if (GetFile.exists(date, 'note', index: index)) {
      File('$notePath/$date/$index.json').delete();
    }

    setState(() {
      page = 0;
    });

    imageCache.clear(); //BRUH
    renameDayNotes();
  }

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

    File(tempImage.path).copy('$photoPath/$date/$index.png');

    setState(() {
      page = index;
    });

    print("Saved image to $photoPath/$date/$index.png");
  }

  @override
  Widget build(BuildContext context) {
    PageController horizontalController = PageController(initialPage: page);
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
        if (data == null) ...[
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

  Widget imageWidget(data) {
    if (data != null) {
      //uploadImage(displayImage);
      return Image(image: FileImage(data));
    } else {
      return const SizedBox(
        height: 500,
        child: Center(child: Text("Add an image!", style: headerMedium)),
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
        if (GetFile.exists(date, "photo", index: index)) ...[
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
          deleteDayNote(index);
          Navigator.pop(context);
          Navigator.pop(context);
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
