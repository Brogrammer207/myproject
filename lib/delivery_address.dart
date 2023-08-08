import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({super.key});

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String dropdownvalue = 'City';

  var items = [
    'City',
    'Borawar',
    'chhapar',
    'sandwa',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Where are you ordered items shipped?',
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
            Lottie.network(
              'https://assets1.lottiefiles.com/private_files/lf30_QLsD8M.json',
              height: 200.0,
              repeat: true,
              reverse: true,
              animate: true,
            ),
            buildTextField(
                'Enter Your Name',
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                )),
            const SizedBox(
              height: 20,
            ),
            buildTextField(
                'Enter Your Phone Number',
                const Icon(
                  Icons.phone,
                  color: Colors.blue,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey.withOpacity(0.2)),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  labelText: 'Select an item',
                  border: InputBorder.none,
                  suffixIcon: DropdownButtonFormField(
                      decoration: InputDecoration(border: InputBorder.none),
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      }),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildTextField(
                'Address(Area and Street)',
                const Icon(
                  Icons.home,
                  color: Colors.blue,
                )),
            const SizedBox(
              height: 80,
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.blue),
              child: const Center(
                  child: Text(
                'CheckOut',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintetxt, Widget icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey.withOpacity(0.2)),
      child: TextField(
        cursorColor: Colors.orange,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(border: InputBorder.none, icon: icon, hintText: hintetxt),
      ),
    );
  }
}
