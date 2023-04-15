// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

import '../../../spec/get_file.dart';

class NotesSection extends StatefulWidget {
  final String date;
  final int index;
  const NotesSection({super.key, required this.date, required this.index});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  late final String _date = widget.date;
  late final _index = widget.index;
  late List<dynamic> defaultNote = json.decode(GetFile.defaultString);
  QuillController controller = QuillController.basic();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  bool _newNote = true;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (_newNote) controller.clear();
    });
  }

  void saveNote(BuildContext context) {
    var jsonString = jsonEncode(controller.document.toDelta().toJson());

    if (GetFile.exists(_date, 'note', index: _index)) {
      File(GetFile.path(_date, 'note', index: _index)).delete();
    }
    File file = File(GetFile.path(_date, 'note', index: _index));
    file.writeAsString(jsonString);
    print("Saved note to ${GetFile.path(_date, 'note', index: _index)}");

    //close keyboard
    focusNode.unfocus();

    //rebuild to maintain text
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (GetFile.exists(_date, 'note', index: _index)) {
      _newNote = false;
      try {
        defaultNote = json.decode(
            File(GetFile.path(_date, 'note', index: _index))
                .readAsStringSync());
      } catch (e) {
        print('Caught $e when trying to save note');
        defaultNote = json.decode(GetFile.errorString);
      }
    }
    controller = QuillController(
        document: Document.fromJson(defaultNote),
        selection: const TextSelection.collapsed(offset: 0));

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(width: 3, color: Colors.black),
            )),
            height: 500,
            child: quillEditor()),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.check),
            onPressed: () => saveNote(context)));
  }

  QuillEditor quillEditor() {
    return QuillEditor(
      controller: controller,
      scrollController: scrollController,
      scrollable: true,
      padding: const EdgeInsets.all(10),
      autoFocus: false,
      focusNode: focusNode,
      readOnly: false,
      expands: true,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
            const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
            const Tuple2(16, 0),
            const Tuple2(0, 0),
            null),
      ),
    );
  }
}
