import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/model/Category.dart';

import 'model/model_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: const DrawerButton(),
        actions: [
          Icon(Icons.search),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching products'),
              );
            }
      
            List<Category> category = snapshot.data!.docs.map((doc) {
              return Category.fromMap(doc.id, doc.data());
            }).toList();
      
            return GridView.builder(
              itemCount: category.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x3600000F),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                category[index].imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                              child: Text(
                                category[index].name,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                );
                // ListTile(
                //   title: Text(products[index].name),
                //   subtitle: Text(products[index].description),
                //   trailing: Text('\$${products[index].price.toStringAsFixed(2)}'),
                //   leading: Image.network(products[index].imageUrl),
                // );
              },
            );
          },
        ),
      
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching products'),
              );
            }
      
            List<Product> products = snapshot.data!.docs.map((doc) {
              return Product.fromMap(doc.id, doc.data());
            }).toList();
      
            return GridView.builder(
              itemCount: products.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x3600000F),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                products[index].imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                              child: Text(
                                products[index].name,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                              child: Text(
                                '\$${products[index].price.toStringAsFixed(2)}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                // ListTile(
                //   title: Text(products[index].name),
                //   subtitle: Text(products[index].description),
                //   trailing: Text('\$${products[index].price.toStringAsFixed(2)}'),
                //   leading: Image.network(products[index].imageUrl),
                // );
              },
            );
          },
        ),
          ],
        ),
      )
      
    );
  }
}
