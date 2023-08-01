import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myproject/model/Category.dart';
import 'package:myproject/productDetailsScreen.dart';

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
          leading: const Icon(Icons.menu),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.search),
          )],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
            SizedBox(
                        height: 180,
                                child: Image.asset(
                                  "assets/images/oil.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ),
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
                    physics:const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30, // Image radius
                                backgroundImage:
                                NetworkImage(category[index].imageUrl),
                              ),
                              const SizedBox(height: 7,),
                              Center(
                                child: Text(
                                  category[index].name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 50,),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(ProductDetailsScreen(
                              productId: products[index].id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                8, 4, 0, 0),
                                        child: Text(
                                          products[index].name,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 2, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                8, 4, 0, 0),
                                        child: Text(
                                          '\$${products[index].price.toStringAsFixed(2)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .startDocked, //specify the location of the FAB
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            print('OK');
          },
          tooltip: "start FAB",
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          elevation: 4.0,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              IconButton(
                icon: Image.asset("assets/images/ic_shop.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/images/ic_wishlist.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/images/ic_notif.png"),
                onPressed: () {},
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
        ));
  }
}
