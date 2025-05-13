import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:myproject/firebase_services/firestore_service.dart';
import 'package:myproject/screens/home_screens/homepage.dart';
import 'package:myproject/screens/auth/signup.dart';
import 'package:pinput/pinput.dart';

import '../home_screens/profile.dart';
import '../../bottom_navigation_bar_screen.dart';
import '../widgets/helper.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController verifyController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Container(
            height:Get.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/logoo.png',
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0,right: 25),
                      child: Pinput(
                        length: 6,
                        showCursor: true,
                        onChanged: (value) => code = value,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 25.0,right: 25),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            OverlayEntry loader = Helper.overlayLoader(context);
                            Overlay.of(context).insert(loader);
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(verificationId: SignUpScreen.verify, smsCode: code);
                            await auth.signInWithCredential(credential);
                            bool userExists = await FirebaseFireStoreService().checkUserProfile();
                            if (userExists == true) {
                              Get.offAll(const BottomNavigationScreen());
                              Helper.hideLoader(loader);
                            } else {
                              Get.offAll(const ProfileScreen(
                                fromLogin: true,
                              ));
                              Helper.hideLoader(loader);
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Wrong Otp",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 16,color: Color(0xffF4BB10),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                    )
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
