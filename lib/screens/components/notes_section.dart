import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotesSection extends StatefulWidget {
  const NotesSection({super.key});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  Widget build(BuildContext context) {
    QuillController _controller = QuillController.basic();
    return Container(
      child: QuillEditor.basic(
        controller: _controller,
        readOnly: false, // true for view only mode
      ),
    );
  }
}
