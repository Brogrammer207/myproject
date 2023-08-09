import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../delivery_address.dart';
import '../../profile.dart';
import '../widgets/cart_button.dart';
import 'cart_screen.dart';
import 'homepage.dart';


const List<TabItem> items = [
  TabItem(
    icon: Icons.home,
    // title: 'Home',
  ),
  TabItem(
    icon: Icons.search_sharp,
    title: 'Shop',
  ),
  TabItem(
    icon: Icons.shopping_cart_outlined,
    title: 'Cart',
  ),
  TabItem(
    icon: Icons.account_box,
    title: 'profile',
  ),
];
class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);

  int selectedIndex = 0;

  List<Widget> homeScreens = [
    const HomePageScreen(),
    const SizedBox(),
    const CartScreen(),
    const SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                Get.to(const ProfileScreen(fromLogin: false,));
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_alarm),
              title: const Text('Orders'),
              onTap: () {
                Get.to(const DeliveryAddress());
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
      ),
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: const Icon(Icons.menu)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CartButton(
            onPressed: (){
              selectedIndex = 2;
              setState(() {});
            },
          )
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: homeScreens,
      ),
      bottomNavigationBar: BottomBarInspiredInside(
        items: items,
        backgroundColor: bgColor,
        color: color2,
        colorSelected: Colors.white,
        indexSelected: selectedIndex,
        onTap: (int index) => setState(() {
          selectedIndex = index;
        }),
        chipStyle: const ChipStyle(convexBridge: true),
        itemStyle: ItemStyle.circle,
        animated: false,
      ),
    );
  }
}
