import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:myproject/helper/new_helper.dart';
import '../../firebase_services/firestore_service.dart';
import '../../model/model_cart_list.dart';
import '../home_screens/cart_screen.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  FirebaseFireStoreService fireStoreService = FirebaseFireStoreService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: fireStoreService.auth.currentUser != null
          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: fireStoreService.getCartList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ModelCartList> cartList = [];
                  if (snapshot.data == null) return const SizedBox();
                  // log(snapshot.data!.docs.map((e) => jsonEncode(e.data())).toList().toString());
                  cartList = snapshot.data!.docs.map((e) => ModelCartList.fromJson(e.data())).toList();
                  int totalAmount = cartList.map((e) => e.productQuantity!.toString().toNum).toList().sum.toInt();

                  return Badge(
                    backgroundColor: Color(0xffF4BB10),
                    offset: const Offset(-1, -5),
                    label: Text(totalAmount.toString()),
                    child: GestureDetector(
                        onTap: (){
                          Get.to(() => const CartScreen());
                        },
                        child: Image.asset('assets/images/cart.png', width: 30, height: 30))
                  );
                }
                return Badge(
                  child: GestureDetector(
                    onTap: (){
                      Get.to(() => const CartScreen());
                    },
                      child: Image.asset('assets/images/cart.png', width: 30, height: 30))

                );
              })
          : const SizedBox.shrink(),
    );
  }
}
