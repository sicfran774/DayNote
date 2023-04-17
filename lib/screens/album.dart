import 'dart:convert';
import 'dart:io';

import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';

import '../spec/get_file.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final File? albumJsonFile = GetFile.loadAlbums();
  late List<Album> albums = [];

  void readAlbumJson() {
    try {
      var json = jsonDecode(albumJsonFile!.readAsStringSync());
      albums = List<Album>.from(json.map((x) => Album.fromJson(x)));
    } catch (e) {
      print('Caught $e, album.json is empty.');
      albums = [];
    }
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

  void createAlbum(String albumName) {
    setState(() {
      albums.add(Album(albumName: albumName, dayNotes: []));
    });
    saveAlbumJson();
  }

  void saveAlbumJson() {
    albumJsonFile?.writeAsString(jsonEncode(albums));
  }

  @override
  Widget build(BuildContext context) {
    readAlbumJson();
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
              for (var album in albums) ...[albumCell(album)]
            ],
          ),
        ),
      ],
    ));
  }

  Widget albumCell(Album album) {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: primaryAppColor),
      child: Text(album.albumName),
    );
  }
}

class Album {
  Album({required this.albumName, required this.dayNotes});

  String albumName;
  List<String> dayNotes = [];

  Album.fromJson(Map<String, dynamic> json)
      : albumName = json['albumName'],
        dayNotes = List.from(json['dayNotes']);

  Map<String, dynamic> toJson() {
    return {
      "albumName": albumName,
      "dayNotes": dayNotes,
    };
  }
}
