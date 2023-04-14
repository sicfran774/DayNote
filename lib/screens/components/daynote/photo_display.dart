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
    List<FileSystemEntity> photos;
    try {
      photos = await directories(0); //get photo array
    } catch (e) {
      return 1;
    }

    if (photos.isEmpty) {
      return 1;
    }

    imageCache.clear(); //BRUH you have to clear the cache
    return photos.length + 1;
  }

  void renameDayNotes() async {
    List<FileSystemEntity> photos = await directories(0); //get photo array
    List<FileSystemEntity> notes = await directories(1); //get note array

    int index = 0, noteIndex = 0;
    for (var photo in photos) {
      /*print(
            'renaming $photo to ${GetFile.path(date, 'photo', index: index)}');*/
      photo.rename(GetFile.path(date, 'photo', index: index));
      try {
        var name = notes[noteIndex]
            .toString()
            .split('/')[8] //get index.json
            .split('.')[0]; //get index number

        if (int.parse(name) == index + 1) {
          //+1 because a day note has been deleted so photo indexes off by 1
          notes[noteIndex].rename(GetFile.path(date, 'note', index: index));
          ++noteIndex;
        }
      } catch (e) {}
      ++index;
    }
  }

  void deleteDayNote(int index) async {
    File('$photoPath/$date/$index.png').delete();

    if (GetFile.exists(date, 'note', index: index)) {
      File('$notePath/$date/$index.json').delete();
    }

    imageCache.clear();
    setState(() {
      page = 0;
    });

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
      imageCache.clear();
    });

    print("Saved image to $photoPath/$date/$index.png");
  }

  void setAsDisplayDayNote(int index) async {
    switchDayNotes(index, 'photo');
    switchDayNotes(index, 'note');
    setState(() {
      page = 0;
    });
  }

  void switchDayNotes(int index, String type) {
    try {
      File(GetFile.path(date, type))
          .renameSync(GetFile.path(date, type, index: 9999));
      File(GetFile.path(date, type, index: index))
          .renameSync(GetFile.path(date, type, index: 0));
      File(GetFile.path(date, type, index: 9999))
          .renameSync(GetFile.path(date, type, index: index));
    } catch (e) {
      return;
    }
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
          child:
              (data == null) ? const Icon(Icons.add) : const Icon(Icons.photo),
          onPressed: () => chooseImageWidget(context, index)),
      body: Stack(children: [
        Center(child: imageWidget(data)),
        if (GetFile.exists(date, "photo", index: index)) ...[
          Container(
              alignment: Alignment.topRight,
              padding: (index == 0)
                  ? const EdgeInsets.all(15)
                  : const EdgeInsets.only(right: 15, top: 7),
              child: (index == 0)
                  ? const Icon(
                      Icons.star,
                      color: starColor,
                      size: 40,
                    )
                  : IconButton(
                      onPressed: () => setAsDisplayDayNote(index),
                      icon: const Icon(Icons.star_border_outlined,
                          color: starColor, size: 40)))
        ],
      ]),
    );
  }

  Widget imageWidget(data) {
    if (data != null) {
      //uploadImage(displayImage);
      return Row(
        children: [
          Expanded(
              child: InteractiveViewer(child: Image(image: FileImage(data)))),
        ],
      );
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
        if (index != 0 && GetFile.exists(date, "photo", index: index)) ...[
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Set as display DayNote'),
            onTap: () {
              setAsDisplayDayNote(index);
              Navigator.pop(context);
            },
          ),
        ],
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
            title: const Text('Delete this DayNote'),
            onTap: () => confirmDelete(context, index),
          ),
        ]
      ],
    );
  }

  void confirmDelete(BuildContext context, int index) {
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
