import 'dart:io';

import 'package:flutter/material.dart';

const double width = 10;
const double height = 100;

class CellImage extends StatefulWidget {
  final int day;
  final File? image;
  const CellImage({super.key, required this.day, required this.image});

  @override
  State<CellImage> createState() => _CellImageState();
}

class _CellImageState extends State<CellImage> {
  late int day = widget.day;
  late File? image = widget.image;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: /*imageWidget(displayImage)*/ imageWidget(image),
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          " ${day.toString()}",
          style: const TextStyle(color: Colors.white),
        ));
  }

  DecorationImage imageWidget(File? displayImage) {
    if (displayImage != null) {
      return DecorationImage(image: FileImage(displayImage), fit: BoxFit.fill);
    } else {
      //print('image not found for $month $day');
      return const DecorationImage(
          image: AssetImage('assets/images/saul.jpg'), fit: BoxFit.fill);
    }
  }
}
