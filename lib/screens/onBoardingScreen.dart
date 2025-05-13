import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/widgets/apptheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_navigation_bar_screen.dart';
import 'auth/signup.dart';
import 'onBoardingList.dart';

class OnBoardingScreen extends StatefulWidget {
  static String route = "/OnBoardingScreen";
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  final RxInt _pageIndex = 0.obs;
  bool loginLoaded = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  int currentIndex = 0;
  RxInt currentIndex12 = 0.obs;
  RxBool currentIndex1 = false.obs;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: OnBoardingData.length + 1,
                  controller: controller,
                  physics: loginLoaded ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  pageSnapping: true,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex.value = index;
                      if (OnBoardingData.length == index) {
                        loginLoaded = true;
                      } else {
                        loginLoaded = false;
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    if (OnBoardingData.length == index) {
                      loginLoaded = true;
                      if (currentUser != null) {
                        return BottomNavigationScreen();
                      } else {
                        return SignUpScreen();
                      }
                    }

                    loginLoaded = false;
                    return OnboardContent(
                      controller: controller,
                      indexValue: _pageIndex.value,
                      image: OnBoardingData[index].image.toString(),
                      title: OnBoardingData[index].title.toString(),
                      description: OnBoardingData[index].desc.toString(),
                    );
                  }),
            ],
          ),
        ));
  }
}

class CustomIndicator extends StatefulWidget {
  final bool isActive;
  const CustomIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  State<CustomIndicator> createState() => _CustomIndicatorState();
}

class _CustomIndicatorState extends State<CustomIndicator> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: widget.isActive ? 30 : 10,
          height: 10,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              color: widget.isActive ? const Color(0xffFFC529) :
              const Color(0xffFFC529).withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
        ));
  }
}

class OnboardContent extends StatefulWidget {
  final String image, title, description;
  final int indexValue;
  final PageController controller;

  const OnboardContent(
      {Key? key,
      required this.controller,
      required this.image,
      required this.title,
      required this.indexValue,
      required this.description})
      : super(key: key);

  @override
  State<OnboardContent> createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * .05,
            ),
            Flexible(
              child: SizedBox(
                height: height * .48,
                width: width,
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.contain,
                ),
                // decoration: BoxDecoration(
                //     image: DecorationImage(image: AssetImage(image), fit: BoxFit.contain,)),
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...List.generate(
                    OnBoardingData.length,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: CustomIndicator(
                        isActive: index == widget.indexValue,
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Column(
                children: [
                  SizedBox(
                    height: height * .05,
                  ),
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: const Color(0xFF121826),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Text(
                    widget.description,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color(0xFF475569),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),

                  SizedBox(
                    height: height * .06,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      GestureDetector(
        onTap: () async {
          if (widget.indexValue == 2) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('onboardingShown', true);

            if (currentUser != null) {
              Get.to(BottomNavigationScreen());
            } else {
              Get.to(SignUpScreen());
            }
          } else {
            widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
               decoration: BoxDecoration(
                color: Color(0xffF4BB10),
                 shape: BoxShape.circle,
               ),
          child:  Icon(Icons.arrow_forward,
          color: widget.indexValue == 2 ? Colors.green : Colors.white,)
        ),
      ),
      SizedBox(
        height: height * .020,
      ),

      SizedBox(
        height: height * .007,
      ),
    ]);
  }
}
