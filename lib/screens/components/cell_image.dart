import 'dart:io';

import 'package:day_note/screens/calendar.dart';
import 'package:flutter/material.dart';

import '../../spec/get_photo.dart';

const double width = 10;
const double height = 100;

class CellImage extends StatefulWidget {
  final int day;
  final File? image;
  final String date;
  const CellImage(
      {super.key, required this.day, required this.date, required this.image});

  @override
  State<CellImage> createState() => _CellImageState();
}

class _CellImageState extends State<CellImage> {
  late int day = widget.day;
  late File? image = widget.image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetPhoto.getPhoto(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: imageWidget(image),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  " ${day.toString()}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  DecorationImage imageWidget(File? image) {
    if (image != null) {
      return DecorationImage(image: FileImage(image), fit: BoxFit.fill);
    } else {
      //print('image not found for $month $day');
      return const DecorationImage(image: AssetImage('assets/images/plus.png'));
    }
  }
}
