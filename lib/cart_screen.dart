import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart Screen'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("cart").snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot products = snapshot.data!.docs[index];
                      return Container(
                        child: ListTile(
                          title: Text(products['product']),
                          leading: Container(
                              height: 150,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image.network(products['imageUrl'])),
                        ),
                      );
                    },
                  );
          },
        )
        
        );
  }
}
