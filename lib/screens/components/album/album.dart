// ignore_for_file: avoid_print

import 'dart:io';

import 'package:day_note/screens/components/album/album_daynote.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';

import 'package:day_note/spec/get_file.dart';
import 'package:day_note/spec/edit.dart';
import 'album_class.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen(
      {super.key, this.addingNote = false, this.dayNoteDate = ""});
  final bool addingNote;
  final String dayNoteDate;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  late File? albumJsonFile;
  late List<Album> albums = [];
  late bool addingNote = widget.addingNote;
  late String dayNoteDate = widget.dayNoteDate;

  Future updateAlbumList() async {
    albums = await GetFile.readAlbumJson();
  }

  Album createAlbum(String albumName) {
    Album newAlbum = Album(albumName: albumName, dayNotes: []);
    albums.add(newAlbum);
    setState(() {
      GetFile.saveAlbumJson(albums);
    });
    return newAlbum;
  }

  @override
  Widget build(BuildContext context) {
    int albumIndex = 0;
    return FutureBuilder(
        future: updateAlbumList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    title: const Text("Albums"),
                    actions: [
                      IconButton(
                          tooltip: "Create a new album",
                          onPressed: () => Edit.nameAlbumDialog(
                                  context,
                                  "Create New Album",
                                  "Type a name for your new album: ",
                                  "Create", () {
                                createAlbum(Edit.textField);
                                Navigator.pop(context);
                              }),
                          icon: const Icon(Icons.add))
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverGrid.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: [
                        for (Album album in albums) ...[
                          albumCell(album, albumIndex++)
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text("Albums")),
            );
          }
        });
  }

  Widget albumCell(Album album, int albumIndex) {
    bool hasDayNote = (album.dayNotes.isNotEmpty);
    String date;
    int photoIndex;

    if (hasDayNote) {
      date = album.dayNotes[0].split('/')[0];
      photoIndex = int.parse(album.dayNotes[0].split('/')[1]);
    } else {
      date = "";
      photoIndex = 0;
    }

    return ElevatedButton(
        onPressed: () {
          if (addingNote) {
            albums[albumIndex].dayNotes.add(dayNoteDate);
            GetFile.saveAlbumJson(albums);
            Navigator.pop(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlbumDayNote(
                          dayNoteList: album.dayNotes,
                          albumIndex: albumIndex,
                          albumName: album.albumName,
                          update: () => setState(() {}),
                        )));
          }
        },
        onLongPress: () {
          Edit.albumOptionsWidget(
              context, albumIndex, albums[albumIndex].albumName, () {
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() {});
          });
        },
        child: Stack(
          children: [
            if (hasDayNote) ...[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(
                            GetFile.path(date, "photo", index: photoIndex)))),
                    color: primaryAppColor),
              ),
            ],
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(child: Text(album.albumName)),
              ],
            ),
          ],
        ));
  }
}
