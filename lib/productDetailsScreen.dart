import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:myproject/model/model_product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('products').doc(widget.productId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Product not found'),
            );
          }

          final productData = snapshot.data!.data()!;
          final product = Product.fromMap(widget.productId, productData);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.imageUrl,
                  height: 300,
                  width: Get.width,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: \$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: Get.width,
                    child: ElevatedButton(
                        onPressed: () {
                          try {
                            FirebaseFirestore.instance.collection('cart').doc(auth?.currentUser?.uid).set({
                              'product': product.name,
                              'price': product.price.toStringAsFixed(2),
                              'description': product.description,
                              'imageUrl': product.imageUrl
                            });
                            Fluttertoast.showToast(
                                msg: "Product Added successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            //Get.to(const CartScreen());
                          } catch (e) {
                            print('Error adding product to cart in Firestore: $e');
                          }
                        },
                        child: const Text("Add to cart")),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
