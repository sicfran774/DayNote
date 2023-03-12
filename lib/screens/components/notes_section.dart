// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

import '../../spec/get_file.dart';

class NotesSection extends StatefulWidget {
  final String date;
  const NotesSection({super.key, required this.date});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  late final String _date = widget.date;
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
    var json = jsonEncode(controller.document.toDelta().toJson());

    if (GetFile.exists(_date, 'note')) {
      File(GetFile.path(_date, 'note')).delete();
    }
    File file = File(GetFile.path(_date, 'note'));
    file.writeAsString(json);
    print("Saved note to ${GetFile.path(_date, 'note')}");

    //close keyboard
    setState(() {
      focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> defaultNote;
    if (GetFile.exists(_date, 'note')) {
      _newNote = false;
      defaultNote =
          json.decode(File(GetFile.path(_date, 'note')).readAsStringSync());
    } else {
      defaultNote = json.decode(GetFile.defaultString);
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
