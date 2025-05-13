import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/admin/addproduct.dart';
import 'package:myproject/screens/galleryScreen.dart';
import 'package:myproject/screens/home_screens/gallery.dart';
import 'package:myproject/screens/widgets/common_app_bar.dart';

import '../screens/orders/orders_screen.dart';
import 'view_products_list.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int deliveredCount = 0;
  int dispatchCount = 0;
  int cancelledCount = 0;

  final int gridItemCount = 20;

  // Generate a random color
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDeliveredCount();
    fetchDispatchCount();
    fetchCancelledCount();
    fetchDeliveredData();
  }

  int deliveredAmountCount = 0;
  double totalDeliveredAmount = 0.0;
  Future<void> fetchDeliveredData() async {
    try {
      // Fetch all documents from the "orders" collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();

      int count = 0;
      double totalAmount = 0.0;

      // Loop through all documents
      for (var doc in snapshot.docs) {
        // Check if the `delivered` field is true
        if (doc.data() != null && doc['delivered'] == true) {
          count++;

          // Access `total_amount` key and parse its value
          String? totalAmountString = doc['total_amount'];
          if (totalAmountString != null && totalAmountString.isNotEmpty) {
            double amount = double.tryParse(totalAmountString) ?? 0.0;
            totalAmount += amount; // Add to the total amount
          } else {
            print("Invalid or missing total_amount for document: ${doc.id}");
          }
        }
      }

      // Update the state to display data in the UI
      setState(() {
        deliveredCount = count;
        totalDeliveredAmount = totalAmount;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchDeliveredCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
      int count = 0;
      for (var doc in snapshot.docs) {
        if (doc['delivered'] == true) {
          count++;
        }
      }

      setState(() {
        deliveredCount = count;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  Future<void> fetchDispatchCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
      int count1 = 0;
      for (var doc in snapshot.docs) {
        if (doc['dispatch'] == true) {
          count1++;
        }
      }

      setState(() {
        dispatchCount = count1;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  Future<void> fetchCancelledCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('isCancelled', isEqualTo: false)
          .get();

      setState(() {
        cancelledCount = snapshot.docs.length; // Count directly from query result
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Admin Panel",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: Get.width,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(21)),
                  child:Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Total Delivered Orders: ${deliveredCount.toString()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Total Dispatch Orders: ${dispatchCount.toString()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child:  Text(
                            'Total Cancelled Orders: ${cancelledCount.toString()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child:  Text(
                            'Total Amount of Delivered Orders: \₹${totalDeliveredAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),


              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  Get.to(const ViewProductsLList());
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(21)),
                  child: const Center(
                      child: Text(
                    'View Product',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const OrdersScreen(
                        admin: true,
                      ));
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(21)),
                  child: const Center(
                      child: Text(
                    'Show Order',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddGalleryScreen());
                },
                child: Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(21)),
                  child: const Center(
                      child: Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


