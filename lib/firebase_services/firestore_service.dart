import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:myproject/helper/helper.dart';

import '../helper/new_helper.dart';
import '../model/profile_model.dart';

enum UpdateType { set, update }

class FirebaseFireStoreService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static String cartCollection = "cart";
  static String productsCollection = "products";
  static String profileCollection = "profile_collection";
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();

  String get userId => auth.currentUser!.uid;

  addToCart({
    required String productId,
    required Map<String, dynamic> productData,
  }) async {
    try {
      final response =
          await fireStore.collection(cartCollection).doc(userId).collection(productsCollection).doc(productId).get();
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
    } catch (e) {
      throw Exception(e);
    }
  }

  Future updatePriceQuantity({
    required String productId,
    required int productQuantity,
  }) async {
    try {
      final response =
          await fireStore.collection(cartCollection).doc(userId).collection(productsCollection).doc(productId).get();
      if (response.exists) {
        await response.reference.update({"product_quantity": productQuantity}).then((value) {
          showToast("Product quantity Updated");
        });
      } else {
        showToast("Product do not exist");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future removeProduct({
    required String productId,
  }) async {
    try {
      final response =
          await fireStore.collection(cartCollection).doc(userId).collection(productsCollection).doc(productId).get();
      if (response.exists) {
        await response.reference.delete().then((value) {
          showToast("Product Removed");
        });
      } else {
        showToast("Product do not exist");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartList() {
    return fireStore.collection(cartCollection).doc(userId).collection(productsCollection).snapshots();
  }

  Future<bool> checkUserProfile() async {
    final response = await fireStore.collection(profileCollection).doc(userId).get();
    if (response.exists) {
      return true;
    }
    return false;
  }

  Future<ModelProfileData?> getProfileDetails() async {
    final response = await fireStore.collection(profileCollection).doc(userId).get();
    if (response.exists) {
      log("Api Repsponse.....    ${jsonEncode(response.data())}");
      if(response.data() == null)return null;
      return ModelProfileData.fromJson(response.data()!);
    }
    return null;
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String address,
    required File profileImage,
    required bool allowChange,
    required BuildContext context,
    required Function(bool gg) updated,
  }) async {
    String profileUrl = profileImage.path;
    OverlayEntry loader = NewHelper.overlayLoader(context);
    try {
      if (allowChange) {
        Overlay.of(context).insert(loader);
        final userProfileImageRef = storageRef.child("user_images/$userId");
        UploadTask task6 = userProfileImageRef.putFile(profileImage);
        profileUrl = await (await task6).ref.getDownloadURL();
      }
      final response = await fireStore.collection(profileCollection).doc(userId).set({
        "email": email,
        "name": name,
        "address": address,
        "profile": profileUrl,
      }).then((value) {
        showToast("Profile updated");
        updated(true);
        NewHelper.hideLoader(loader);
        return true;
      });
      NewHelper.hideLoader(loader);
      print("kkkkkkdkskdakdsakdkadkadkas....");
      return false;
    } catch(e){
      NewHelper.hideLoader(loader);
      throw Exception(e);
    } finally{
      NewHelper.hideLoader(loader);
    }
  }
}
