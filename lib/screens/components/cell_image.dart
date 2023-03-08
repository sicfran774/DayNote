import 'dart:io';
import 'package:flutter/material.dart';
import '../../spec/get_photo.dart';

const double width = 10;
const double height = 100;

class CellImage extends StatefulWidget {
  final int day;
  final String date;
  const CellImage({super.key, required this.day, required this.date});

  @override
  State<CellImage> createState() => _CellImageState();
}

class _CellImageState extends State<CellImage> {
  late int day = widget.day;
  late String date = widget.date;

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
                  image: imageWidget(snapshot.data),
                  border: Border.all(),
                ),
                child: Text(
                  " ${day.toString()}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ));
          } else {
            return const SizedBox(width: width, height: height);
          }
        });
  }

  DecorationImage imageWidget(File? image) {
    if (image != null) {
      return DecorationImage(image: FileImage(image), fit: BoxFit.fill);
    } else {
      //print('image not found for $day');
      return const DecorationImage(image: AssetImage('assets/images/plus.png'));
    }
  }
}
