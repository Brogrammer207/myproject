import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
String? fieldName;
  String? fieldValue;

  void fetchData() async {
    try {
      // Replace 'users' with your Firestore collection name
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('cart').doc(currentUserId).get();

      if (snapshot.exists) {
        // Replace 'field_name' with the name of the field you want to fetch
        fieldName = 'field_name';
        fieldValue = snapshot.get("name");
      } else {
        fieldName = null;
        fieldValue = null;
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    if (fieldName != null && fieldValue != null) {
      return Text('$fieldName: $fieldValue');
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
