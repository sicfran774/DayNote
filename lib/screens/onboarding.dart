import 'package:day_note/screens/components/bottom_bar.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:day_note/spec/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.newUser});
  final bool newUser;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  late bool newUser = widget.newUser;
  late List<OnboardPage> pages;
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);

    pages = [
      if (newUser) ...[
        OnboardPage(
            title: "Welcome to DayNote!",
            description: "Here's a little tutorial to get you going",
            image: "assets/images/icon.png",
            border: false),
      ],
      OnboardPage(
          title: "Choose a date",
          description: "Tap on any cell of the calendar to select that day",
          image: "assets/images/step1.png"),
      OnboardPage(
          title: "Add a photo",
          description: "Tap on the plus to bring up options to upload a photo",
          image: "assets/images/step2.png"),
      OnboardPage(
          title: "Add a note",
          description:
              "Awesome! Now you can scroll down and tap below the photo to start typing a note. Notes are automatically saved as you type.",
          image: "assets/images/step3.png"),
      OnboardPage(
          title: "Add multiple photos",
          description:
              "You can have more than one photo! Swipe right to generate a new DayNote",
          image: "assets/images/step4.png"),
      OnboardPage(
          title: "Display specific photo",
          description:
              "Tap the photo options button, then tap \"Set as display DayNote\" to make that DayNote show up on the calendar",
          image: "assets/images/step5.png"),
      OnboardPage(
          title: "Create an album",
          description:
              "To create a new album, tap the plus icon at the top right of the screen",
          image: "assets/images/albumStep2.png"),
      OnboardPage(
          title: "Add to an album",
          description:
              'If you want to add a DayNote to an album, tap the bottom right photo button, and tap "Add this DayNote to an album"',
          image: "assets/images/albumStep1.png"),
      if (newUser) ...[
        OnboardPage(
            title: "That's all! Let's get started!",
            description: "You can view this tutorial again in the Settings",
            image: "assets/images/icon.png",
            border: false),
      ]
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: tutorial()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  pages.length,
                  (index) => Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: PageIndicator(onPage: index == currentPage)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    if (newUser) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (route) => const BottomBar()));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Skip"),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      if (currentPage == pages.length - 1) {
                        if (newUser) {
                          Navigator.popUntil(context, (route) => false);
                          Navigator.pushNamed(context, '/calendar');
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    child: const Icon(Icons.arrow_right_alt_sharp),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget tutorial() {
    return PageView.builder(
        itemCount: pages.length,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) => individualPage(
            pages[index].title, pages[index].description, pages[index].image,
            border: pages[index].border));
  }

  Widget individualPage(String title, String description, String image,
      {bool border = false}) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Container(
            constraints: BoxConstraints.loose(const Size(260, 500)),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: (border) ? Border.all(color: Colors.white) : null,
                image: DecorationImage(image: AssetImage(image))),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: headerLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            description,
            style: dayStyle,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Future<bool> isNewUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('newUser') ?? true;
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, this.onPage = false});
  final bool onPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          color: (onPage) ? white : primaryAppColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }
}

class OnboardPage {
  final String title, description, image;
  final bool border;

  OnboardPage({
    required this.title,
    required this.description,
    required this.image,
    this.border = true,
  });
}
