import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/phonepe_pg.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/images/back.png'),
            )),
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "Enter amount", border: OutlineInputBorder()),
            ),
            SizedBox(height: 100,),
            GestureDetector(
              onTap: (){
                PhonepePg(context: context, amount: int.parse(textEditingController.text)).init();
              },
              child: Container(
                height: 40,
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffF4BB10)),
                child: const Center(
                    child: Text(
                      'Check out',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
