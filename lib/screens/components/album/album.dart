// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/screens/components/album/album_daynote.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';

import '../../../spec/get_file.dart';
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

  void createAlbumDialog() {
    String text = "";
    Widget cancel = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    Widget create = TextButton(
        onPressed: () {
          Navigator.pop(context);
          createAlbum(text);
        },
        child: const Text("Create"));

    AlertDialog confirmation = AlertDialog(
      title: const Center(child: Text("Create New Album")),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Type a name for your new album: "),
            TextField(
              onChanged: (value) {
                text = value;
              },
            ),
          ],
        ),
      ),
      actions: [cancel, create],
    );

    showDialog(
        context: context, builder: (BuildContext context) => confirmation);
  }

  Album createAlbum(String albumName) {
    Album newAlbum = Album(albumName: albumName, dayNotes: []);
    albums.add(newAlbum);
    saveAlbumJson();
    return newAlbum;
  }

  void saveAlbumJson() {
    albumJsonFile = GetFile.loadAlbums();
    albumJsonFile?.writeAsString(jsonEncode(albums));
    setState(() {});
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
                          onPressed: () => createAlbumDialog(),
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
            return const CircularProgressIndicator();
          }
        });
  }

  Widget albumCell(Album album, int albumIndex) {
    bool hasDayNote = (album.dayNotes.isNotEmpty);
    String date;
    int index;

    if (hasDayNote) {
      date = album.dayNotes[0].split('/')[0];
      index = int.parse(album.dayNotes[0].split('/')[1]);
    } else {
      date = "";
      index = 0;
    }

    return ElevatedButton(
        onPressed: () {
          if (addingNote) {
            albums[albumIndex].dayNotes.add(dayNoteDate);
            saveAlbumJson();
            Navigator.pop(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AlbumDayNote(dayNoteList: album.dayNotes)));
          }
        },
        child: Stack(
          children: [
            if (hasDayNote) ...[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                            File(GetFile.path(date, "photo", index: index)))),
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
