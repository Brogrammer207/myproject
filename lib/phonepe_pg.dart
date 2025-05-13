import 'dart:convert' show base64Encode, jsonEncode, utf8;
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import 'checkout_page.dart';

class PhonepePg {
  int amount;
  BuildContext context;

  PhonepePg({required this.context, required this.amount});
  String marchentId = "PGTESTPAYUAT86";
  String salt = "96434309-7796-489d-8924-ab56988a6076";
  int saltIndex = 1;
  String callbackURL = "https://www.webhook.site/callback-url";
  String apiEndPoint = "/pg/v1/pay";

  init() {
    PhonePePaymentSdk.init("SANDBOX", null, marchentId, true).then((val) {
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
      "merchantTransactionId": "sasa829292",
      "merchantUserId": "asas", // login
      "amount": amount * 100, // paisa
      "callbackUrl": callbackURL,
      "mobileNumber": "9876543210", // login
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    log(body.toString());
    String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
    var byteCodes = utf8.encode(bodyEncoded + apiEndPoint + salt);
    String checksum = "${sha256.convert(byteCodes)}###$saltIndex";
    PhonePePaymentSdk.startTransaction(bodyEncoded, callbackURL, checksum, "")
        .then((success) {
      log("Payment success ${success}");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (a) => CheckoutPage()), (e) => false);
    }).catchError((error) {
      log("Payment failed ${error}");
    });
  }
}
