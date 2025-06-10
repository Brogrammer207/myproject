import 'dart:convert' show base64Encode, jsonEncode, utf8;
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import 'bottom_navigation_bar_screen.dart';

class PhonepePg {
  int amount;
  BuildContext context;

  PhonepePg({required this.context, required this.amount});
  String marchentId = "M2331HMEVX8A8";
  String salt = "e5446df8-12f1-41e6-9cea-126eea8a4005";
  int saltIndex = 1;
  String callbackURL = "https://us-central1-borawar-oil-meal.cloudfunctions.net/phonepeCallback";
  String apiEndPoint = "/pg/v1/pay";
  String flowId = "";


  init() {
    PhonePePaymentSdk.init("PRODUCTION", flowId, marchentId, true).then((val) {
      print('PhonePe SDK Initialized - $val');
      startTransaction();
    }).catchError((error) {
      print('PhonePe SDK error - $error');
      return <dynamic>{};
    });
  }

  startTransaction() {
    Map body = {
      "merchantId": marchentId,
      "merchantTransactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "merchantUserId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "amount": amount * 100,
      "callbackUrl": callbackURL,
      "mobileNumber": "9928634555",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    log(body.toString());

    String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
    var byteCodes = utf8.encode(bodyEncoded + apiEndPoint + salt);
    String checksum = "${sha256.convert(byteCodes)}###$saltIndex";


    PhonePePaymentSdk.startTransaction(bodyEncoded, callbackURL, checksum, "").then((result) {
      log("Payment result: $result");

      if (result is Map && result['status'] == "SUCCESS") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (a) => BottomNavigationScreen()),
              (e) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Payment Failed"),
            content: Text(result?['error'] ?? "Unknown error"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          ),
        );
      }
    }).catchError((error) {
      log("Payment failed: $error");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Transaction Error"),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    });
  }
}
