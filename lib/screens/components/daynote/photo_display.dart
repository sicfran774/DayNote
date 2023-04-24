// ignore_for_file: avoid_print

import 'dart:io';
import 'package:day_note/screens/components/album/album.dart';
import 'package:day_note/screens/components/daynote/notes_section.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/edit.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../spec/get_file.dart';
import '../album/album_class.dart';

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
  final FocusNode focusNode = FocusNode();
  late String date = widget.date;
  late String? title = widget.title;
  late int currentPage = 0;

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

  void deleteDayNote(int index) async {
    List<FileSystemEntity> photos = await directories(0); //get photo array
    List<bool> hasNote = [];

    for (int i = 0; i < photos.length; i++) {
      if (GetFile.exists(date, 'note', index: i)) {
        hasNote.add(true);
      } else {
        hasNote.add(false);
      }
    }

    File('$photoPath/$date/$index.png').deleteSync();
    await verifyAlbums('$date/$index', delete: true); //remove from albums
    print('photo deleted $index');
    hasNote.removeAt(index);

    if (GetFile.exists(date, 'note', index: index)) {
      File('$notePath/$date/$index.json').deleteSync();
      print('note deleted $index');
    }

    imageCache.clear();
    renameDayNotes(hasNote);

    showSnackBarAlert("Deleted DayNote");
  }

  void renameDayNotes(List<bool> hasNote) async {
    List<FileSystemEntity> photos = await directories(0); //get photo array

    int index = 0;
    for (var photo in photos) {
      String photoString = photo.toString().split('/')[7].split('/')[0];
      String photoIndex = photo.toString().split('/')[8].split('.')[0];

      photo.renameSync(GetFile.path(date, 'photo', index: index));
      print('photo: renaming $photoIndex to $index');
      await verifyAlbums("$photoString/$photoIndex",
          newFileName: "${photoString.split('/')[0]}/$index");

      if (GetFile.exists(date, 'note', index: int.parse(photoIndex))) {
        print('note: renaming $photoIndex to $index');
        File(GetFile.path(date, 'note', index: int.parse(photoIndex)))
            .renameSync(GetFile.path(date, 'note', index: index));
      }

      ++index;
    }
    setState(() {
      imageCache.clear();
    });
  }

  void deleteAllDayNotes() async {
    List<FileSystemEntity> photos = await directories(0); //get photo array
    List<FileSystemEntity> notes = await directories(1); //get note array

    for (var photo in photos) {
      String photoString = photo.toString().split('/')[7].split('/')[0];
      String photoIndex = photo.toString().split('/')[8].split('.')[0];
      await verifyAlbums("$photoString/$photoIndex", delete: true);
      print("deleting $photoString/$photoIndex from albums");
      photo.delete();
    }
    for (var note in notes) {
      note.delete();
    }

    setState(() {
      currentPage = 0;
    });

    showSnackBarAlert("Deleted all DayNotes");
  }

  void showSnackBarAlert(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
    ));
  }

  Future choosePhoto(ImageSource source, int index) async {
    Navigator.pop(context);
    XFile? tempImage = await _picker.pickImage(source: source);

    if (tempImage == null) {
      return null;
    }

    if (GetFile.exists(date, 'photo', index: index)) {
      print('$date./$index.png already exists, deleting');
      await File('$photoPath/$date/$index.png').delete();
    }

    File(tempImage.path).copy('$photoPath/$date/$index.png');

    setState(() {
      currentPage = index;
      imageCache.clear();
    });

    print("Saved image to $photoPath/$date/$index.png");
  }

  void setAsDisplayDayNote(int index) {
    switchDayNotes(index, 'photo');
    switchDayNotes(index, 'note');

    //For albums
    verifyAlbums("$date/$index", newFileName: "$date/0", switching: true);

    setState(() {
      currentPage = 0;
    });
  }

  void switchDayNotes(int index, String type) {
    if (GetFile.exists(date, type)) {
      File(GetFile.path(date, type))
          .renameSync(GetFile.path(date, type, index: 9999));
    }
    if (GetFile.exists(date, type, index: index)) {
      File(GetFile.path(date, type, index: index))
          .renameSync(GetFile.path(date, type, index: 0));
    }

    if (GetFile.exists(date, type, index: 9999)) {
      File(GetFile.path(date, type, index: 9999))
          .renameSync(GetFile.path(date, type, index: index));
    }

    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final PageController horizontalController =
        PageController(initialPage: currentPage);
    GetFile.generateNewDay(date);
    return FutureBuilder(
        future: amountOfDayNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              endDrawer: SizedBox(
                width: 250,
                child: Drawer(
                    backgroundColor: gitHubBlack,
                    shadowColor: Colors.blueGrey,
                    child: ListView(
                      children: [
                        const DrawerHeader(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Center(
                              child: Text(
                                "DayNote Options",
                                style: headerLarge,
                              ),
                            )),
                        ListTile(
                          tileColor: primaryAppColor,
                          leading: const Icon(
                            Icons.ios_share_rounded,
                            color: white,
                          ),
                          title: const Text('Upload this DayNote',
                              style: headerMedium),
                          onTap: () {
                            showSnackBarAlert(
                                "Feature available in the future!");
                          },
                        ),
                        ListTile(
                          tileColor: primaryAppColor,
                          leading: const Icon(
                            Icons.delete_forever_outlined,
                            color: white,
                          ),
                          title: const Text('Delete all DayNotes',
                              style: headerMedium),
                          onTap: () {
                            Edit.confirmDelete(context, "Delete All DayNotes",
                                "Are you sure you want to clear all DayNotes for this day?",
                                () {
                              deleteAllDayNotes();
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    )),
              ),
              backgroundColor: gitHubBlack,
              appBar: AppBar(
                title: Text(title!),
                centerTitle: true,
              ),
              body: PageView.builder(
                controller: horizontalController,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: GetFile.getFile(date, 'photo', index: index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return individualDayNote(snapshot.data, index);
                        } else {
                          return Container(color: gitHubBlack);
                        }
                      });
                },
                itemCount: snapshot.data,
                onPageChanged: (index) {
                  currentPage = index;
                },
              ),
              floatingActionButton: FloatingActionButton(
                  tooltip: (GetFile.exists(date, 'photo', index: currentPage))
                      ? "DayNote options"
                      : "Add a new photo",
                  child: (!GetFile.exists(date, 'photo', index: currentPage))
                      ? const Icon(Icons.add)
                      : const Icon(Icons.photo),
                  onPressed: () {
                    chooseImageWidget(context, currentPage);
                    focusNode.unfocus();
                  }),
            );
          } else {
            return Container(color: gitHubBlack);
          }
        });
  }

  Widget individualDayNote(data, int index) {
    return GestureDetector(
      onTap: () {
        if (focusNode.hasPrimaryFocus) {
          GetFile.showSnackBarAlert(context, "Note saved", seconds: 1);
        }
        focusNode.unfocus();
      },
      child: SingleChildScrollView(
          child: Column(
        children: [
          if (data == null) ...[
            photoSection(data),
          ] else ...[
            photoSection(data),
            NotesSection(date: date, index: index, focusNode: focusNode),
          ]
        ],
      )),
    );
  }

  Widget photoSection(data) {
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
            leading: const Icon(Icons.photo_camera_back_rounded),
            title: const Text("Add this DayNote to an album"),
            onTap: () => addToAlbum(index),
          ),
          ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete this DayNote'),
              onTap: () => Edit.confirmDelete(context, "Delete Day Note",
                      "Are you sure you want to delete this photo and note?",
                      () {
                    deleteDayNote(index);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  })),
        ]
      ],
    );
  }

  /* Album Functions */

  void addToAlbum(int index) {
    print("Adding $index to album");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlbumScreen(
                  addingNote: true,
                  dayNoteDate: '$date/$index',
                )));
  }

  //If at any point that a DayNote is renamed/deleted,
  //you must check all the albums if that DayNote is within any of them
  Future verifyAlbums(String oldFileName,
      {bool delete = false,
      bool switching = false,
      String newFileName = ""}) async {
    List<Album> albums = await GetFile.readAlbumJson();
    for (Album album in albums) {
      if (delete) {
        album.dayNotes.removeWhere((dayNote) => dayNote == oldFileName);
      } else if (switching) {
        for (int i = 0; i < album.dayNotes.length; i++) {
          if (album.dayNotes[i] == oldFileName) {
            print("renaming ${album.dayNotes[i]} to $newFileName");
            album.dayNotes[i] = newFileName;
          } else if (album.dayNotes[i] == newFileName) {
            print("renaming ${album.dayNotes[i]} to $oldFileName");
            album.dayNotes[i] = oldFileName;
          }
        }
      } else {
        for (int i = 0; i < album.dayNotes.length; i++) {
          if (album.dayNotes[i] == oldFileName) {
            print("renaming ${album.dayNotes[i]} to $newFileName");
            album.dayNotes[i] = newFileName;
          }
        }
      }
    }
    GetFile.saveAlbumJson(albums);
  }

  /* Album Functions End */

  /* Firebase */

  void uploadImage(XFile? file) async {
    Reference? imagesRef = storageRef.child(date);
    try {
      await imagesRef.putFile(File(file!.path));
    } on FirebaseException catch (e) {}
  }
}
