import 'dart:async';

import 'package:day_note/screens/onboarding.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:day_note/screens/components/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'spec/get_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetFile.generateDirectories();
  GetFile.cleanAlbumList(await GetFile.readAlbumJson());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DayNote',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColorDark: gitHubBlack,
          scaffoldBackgroundColor: gitHubBlack),
      home: const SplashScreen(),
      routes: {'/calendar': (context) => const BottomBar()},
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Future checkNewUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool newUser = prefs.getBool('newUser') ?? true;

    Duration duration = const Duration(seconds: 1);

    if (!newUser) {
      return Timer(duration, navigateBottomBar);
    } else {
      await prefs.setBool('newUser', false);
      return Timer(duration, navigateOnboarding);
    }
  }

  void navigateBottomBar() {
    Navigator.pushNamed(context, '/calendar');
  }

  void navigateOnboarding() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const OnboardingScreen(
              newUser: true,
            )));
  }

  @override
  Widget build(BuildContext context) {
    checkNewUser();
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
