import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/screens/home_screens/homepage.dart';
import 'package:myproject/screens/onBoardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_services/firestore_service.dart';
import 'screens/auth/signup.dart';
import 'screens/home_screens/profile.dart';
import 'bottom_navigation_bar_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  next() {
    Timer(const Duration(seconds: 2), () async {
      checkLogin();
    });
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboardingShown') ?? false;

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (!onboardingShown) {
      // Show onboarding for the first time
      Get.offAll(() => const OnBoardingScreen());
    } else if (currentUser != null) {
      // User is logged in and has already seen onboarding
      bool userExists = await FirebaseFireStoreService().checkUserProfile();
      if (userExists == true) {
        Get.offAll(() => const BottomNavigationScreen());
      } else {
        Get.offAll(() => const ProfileScreen(fromLogin: true));
      }
    } else {
      // Not logged in and onboarding already shown
      Get.offAll(() => const SignUpScreen());
    }
  }


  @override
  void initState() {
    super.initState();
    next();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: Get.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/borawarlogo.png',
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
