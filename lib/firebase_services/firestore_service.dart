import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/helper/helper.dart';

class FirebaseFireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static String cartCollection = "cart";
  static String products = "products";
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser!.uid;

  addToCart({
    required String productId,
    required Map<String, dynamic> productData,
}) async {
    try {
      final response = await fireStore.collection(cartCollection).doc(userId).collection(products).doc(productId).get();
      if (response.exists) {
        showToast("Product Already Exists In Cart");
        return;
      }
      response.reference.set({
        "product_id": productId,
        "product_details": productData,
        "product_quantity": 1,
      }).then((value) {
        showToast("Product Added to cart");
      });
    } catch(e){
      throw Exception(e);
    }
  }

  Future updatePriceQuantity({
    required String productId,
    required int productQuantity,
}) async {
    try {
      final response = await fireStore.collection(cartCollection).doc(userId).collection(products).doc(productId).get();
      if (response.exists) {
        showToast("Product Already Exists In Cart");
        await response.reference.update({
          "product_quantity" : productQuantity
        }).then((value) {
          showToast("Product quantity Updated");
        });
      } else {
        showToast("Product do not exist");
      }
    } catch(e){
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartList() {
    return fireStore.collection(cartCollection).doc(userId).collection(products).snapshots();
  }


}