import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/firebase_services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../admin/homepage.dart';
import '../../helper/helper.dart';
import '../auth/signup.dart';
import '../check_out/delivery_address.dart';
import '../orders/orders_screen.dart';
import '../privacypolicyScreen.dart';
import '../storelistScreen.dart';
import '../termsconditionsScreen.dart';
import 'profile.dart';
import '../orders/address_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseFireStoreService fireStoreService = FirebaseFireStoreService();

  bool get adminAccess => fireStoreService.auth.currentUser?.displayName.toString() == "Admin";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF4BB10),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/borawarlogo.png',
                  height: 100,
                ),
                const Text(
                  'Borawar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          if (adminAccess)
            ListTile(
              leading: const Icon(CupertinoIcons.settings_solid),
              title: const Text('Admin Control'),
              onTap: () {
                // Handle the tap on the Home item
                Get.to(() => const AdminHomePage());
              },
            ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle the tap on the Home item
              Get.back();
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('profile'),
            onTap: () {
              if (fireStoreService.userLoggedIn) {
                Get.to(() => const ProfileScreen(
                      fromLogin: false,
                    ));
              } else {
                Get.to(() => const SignUpScreen());
              }
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Store list'),
            onTap: () {
                Get.to(() => const StoreListScreen());
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.access_alarm),
            title: const Text('Orders'),
            onTap: () {
              if (fireStoreService.userLoggedIn) {
                Get.to(() => const OrdersScreen());
              } else {
                Get.to(() => const SignUpScreen());
              }
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.map_pin_ellipse),
            title: const Text('Address'),
            onTap: () {
              if (fireStoreService.userLoggedIn) {
                Get.to(() => const AddressScreen());
              } else {
                Get.to(() => const SignUpScreen());
              }
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Contact Us'),
            onTap: () {
              launch("tel://9928634555");
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Privacy Policy'),
            onTap: () {
              Get.to(Privacypolicyscreen());
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Terms & Conditions'),
            onTap: () {
            Get.to(Termsconditionsscreen());
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            onTap: () async {
              User? user = FirebaseAuth.instance.currentUser;
              await user!.delete();
              showToast("Your account has been deleted");
              Get.to(const SignUpScreen());
            },
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              FirebaseAuth.instance.signOut().then((value) {
                Get.offAll(const SignUpScreen());
                showToast("Logged Out Successfully");
              });
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.exit_to_app),
          //   title: const Text('AboutUs'),
          //   onTap: () {
          //     // Handle the tap on the Logout item
          //   },
          // ),
        ],
      ),
    );
  }
}
