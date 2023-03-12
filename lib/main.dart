import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/components/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'spec/get_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetFile.generateDirectories();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayNote',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColorDark: gitHubBlack,
          scaffoldBackgroundColor: gitHubBlack),
      home: const BottomBar(),
    );
  }
}
