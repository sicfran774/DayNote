import 'dart:io';
import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:day_note/spec/get_file.dart';

const double width = 100;
const double height = 100;

class CellImage extends StatefulWidget {
  final int day;
  final String date;
  final bool today;
  const CellImage(
      {super.key, required this.day, required this.date, this.today = false});

  @override
  State<CellImage> createState() => _CellImageState();
}

class _CellImageState extends State<CellImage> {
  late int day = widget.day;
  late String date = widget.date;
  late bool today = widget.today;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetFile.getFile(date, 'photo'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: imageWidget(snapshot.data),
                  border: (today)
                      ? Border.all(color: highlightCellColor)
                      : Border.all(),
                  color: cellColor,
                ),
                child: Text(
                  " ${day.toString()}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ));
          } else {
            return Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(color: cellColor),
              child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  child: const CircularProgressIndicator()),
            );
          }
        });
  }

  DecorationImage imageWidget(File? image) {
    try {
      if (image != null) {
        return DecorationImage(image: FileImage(image), fit: BoxFit.cover);
      } else {
        //print('image not found for $day');
        return const DecorationImage(
            opacity: 0.5, image: AssetImage('assets/images/plus.png'));
      }
    } catch (e) {
      return const DecorationImage(
          opacity: 0.5, image: AssetImage('assets/images/plus.png'));
    }
  }
}
