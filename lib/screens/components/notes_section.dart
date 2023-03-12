import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';

class NotesSection extends StatefulWidget {
  const NotesSection({super.key});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  QuillController controller = QuillController.basic();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
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
