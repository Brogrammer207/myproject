import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../check_out/delivery_address.dart';
import '../orders/orders_screen.dart';
import 'profile.dart';
import '../orders/address_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/borawarlogo.png',
                  height: 100,
                ),
                const Text(
                  'Borawar Store',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle the tap on the Home item
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('profile'),
            onTap: () {
              Get.to(()=> const ProfileScreen(fromLogin: false,));
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_alarm),
            title: const Text('Orders'),
            onTap: () {
              Get.to(()=> const OrdersScreen());
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.map_pin_ellipse),
            title: const Text('Address'),
            onTap: () {
              Get.to(()=> const AddressScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('AboutUs'),
            onTap: () {
              // Handle the tap on the Logout item
            },
          ),
        ],
      ),
    );
  }
}
