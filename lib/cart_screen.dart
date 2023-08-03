import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

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
                      DocumentSnapshot products =
                          snapshot.data!.docs[index];
                      return  ListTile(
                        leading: Container(
                          height: 100,
                          width: 60,
                          child: Image.network(products['imageUrl'],fit: BoxFit.fill,)),
                        title: Text(products['product']),
                        subtitle: Text(products['description']),
                        trailing: Text(products['price']),
                      );
                    },
                  );
          },
        ));
  }
}
