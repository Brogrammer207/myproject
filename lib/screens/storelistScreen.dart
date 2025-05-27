import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store List'),
        backgroundColor: const Color(0xFFFFC107),
        elevation: 0,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.keyboard_arrow_left_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.white),
          Container(
            height: 150,
            color: const Color(0xFFFFC107),
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Store',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 70,
            left: 0,
            right: 0,
            bottom: 0,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('storelist').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No stores available'));
                }

                final stores = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    final name = store['name'] ?? 'Unnamed Store';
                    final rating = double.tryParse(store['rating']?.toString() ?? '0') ?? 0.0;
                    final priceTime = store['priceTime'] ?? '';
                    final imageUrl = store['imageUrl'] ?? '';

                    return StoreCard(
                      name: name,
                      rating: rating,
                      priceTime: priceTime,
                      imageUrl: imageUrl,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String name;
  final double rating;
  final String priceTime;
  final String imageUrl;

  const StoreCard({
    super.key,
    required this.name,
    required this.rating,
    required this.priceTime,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(imageUrl, fit: BoxFit.fitWidth)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    priceTime,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
