import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text("Albums"),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell(),
              albumCell()
            ],
          ),
        ),
      ],
    ));
  }

  Widget albumCell() {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: primaryAppColor),
    );
  }
}
