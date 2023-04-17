// ignore_for_file: avoid_print

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
  late File? albumJsonFile;
  late List<Album> albums = [];

  void readAlbumJson() async {
    try {
      if (!GetFile.albumJsonExists()) {
        return;
      }
      albumJsonFile = GetFile.loadAlbums();
      //Get JSON file and decode it into string
      var json = jsonDecode(albumJsonFile!.readAsStringSync());
      //Separate each object, put it as an array
      albums = List<Album>.from(json.map((x) => Album.fromJson(
          x))); //Album.fromJson is an automatic json parser defined in the Album class
    } catch (e) {
      print('Caught $e');
      await Future.delayed(const Duration(milliseconds: 500));
      readAlbumJson();
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
    albumJsonFile = GetFile.loadAlbums();
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
      ),
    );
  }

  Widget albumCell(Album album) {
    return ElevatedButton(
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(color: primaryAppColor),
        child: Text(album.albumName),
      ),
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
