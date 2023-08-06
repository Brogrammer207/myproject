import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id; // Document ID from Firestore
  String name;
  double price;
  String description;
  String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  // Factory method to create a Product object from a map and document ID
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
    static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      name: snap['name'],
      price: snap['price'],
      imageUrl: snap['imageUrl'],
      description: snap['description'],
      id: snap['id'],
    );
    return product;
  }
}