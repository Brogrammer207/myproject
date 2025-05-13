import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myproject/helper/new_helper.dart';
import 'package:myproject/screens/check_out/delivery_address.dart';

import '../../firebase_services/firestore_service.dart';
import '../../model/model_cart_list.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseFireStoreService fireStoreService = FirebaseFireStoreService();

  bool updatingValue = false;

  updateValue({
    required String productId,
    required int productQuantity,
  }) {
    if (updatingValue == true) return;
    try {
      updatingValue = true;
      if (productQuantity != 0) {
        fireStoreService.updatePriceQuantity(productId: productId, productQuantity: productQuantity).then((value) {
          updatingValue = false;
        }).catchError((e) {
          updatingValue = false;
        });
      } else {
        fireStoreService.removeProduct(productId: productId).then((value) {
          updatingValue = false;
        }).catchError((e) {
          updatingValue = false;
        });
      }
    } catch (e) {
      updatingValue = false;
      return;
    } finally {
      updatingValue = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: fireStoreService.userLoggedIn
            ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: fireStoreService.getCartList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ModelCartList> cartList = [];
                    if (snapshot.data == null) return const SizedBox();
                    cartList = snapshot.data!.docs.map((e) => ModelCartList.fromJson(e.data())).toList();

                    double totalAmount = cartList
                        .map((e) => e.productQuantity!.toString().toNum * e.productDetails!.price.toString().toNum)
                        .toList()
                        .sum
                        .toDouble();
                    if (cartList.isEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Lottie.asset("assets/images/wishlist.json"),
                            ),
                            Center(
                              child: Text(
                                'Your Cart is empty',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartList.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = cartList[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x3600000F),
                                          offset: Offset(0, 2),
                                        )
                                      ], borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: NetworkImage(item.productDetails!.imageUrl.toString()),
                                          fit: BoxFit.cover,
                                        )
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productDetails!.name.toString(),
                                            style: const TextStyle(
                                                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            item.productDetails!.price.toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  int updateNew = item.productQuantity! - 1;
                                                  updateValue(productId: item.productId!, productQuantity: updateNew);
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffF4BB10), //
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    '--',
                                                    style: TextStyle(color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Center(
                                                  child: Text(
                                                item.productQuantity.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  int updateNew = item.productQuantity! + 1;
                                                  updateValue(productId: item.productId!, productQuantity: updateNew);
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffF4BB10), // border color
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    '+',
                                                    style: TextStyle(color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (cartList.isNotEmpty)
                          Container(
                            height: 190,
                            width: Get.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Subtotal',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            '₹ $totalAmount',
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 30.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tax and Fees',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            '₹ ${00}',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            '₹ $totalAmount',
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const SelectAddressScreen());
                                      },
                                      child: Container(
                                        width: Get.width,
                                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF4BB10),
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ]),
                                        child: Center(
                                          child: const Text(
                                            'CheckOut',
                                            style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Lottie.asset("assets/images/wishlist.json"),
                    ),
                    Center(
                      child: Text(
                        'Your Cart is empty',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
