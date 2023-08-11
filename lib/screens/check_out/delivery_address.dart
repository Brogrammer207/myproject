import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../firebase_services/firestore_service.dart';
import '../../model/model_address.dart';
import '../orders/address_screen.dart';
import '../widgets/loading_animation.dart';
import 'check_out_screen.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {

  final TextEditingController addressName = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController landMark = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FirebaseFireStoreService fireStoreService = FirebaseFireStoreService();

  bool apiLoaded = false;

  bool updating = false;

  updateAddress(){
    if(formKey.currentState!.validate()) {
      if(updating == true)return;
      updating = true;
      fireStoreService.updateAddress(
          title: addressName.text.trim(),
          phone: number.text.trim(),
          city: city.text.trim(),
          address: address.text.trim(),
          landmark: landMark.text.trim()).then((value) {
        Get.to(()=> CheckOutScreen(
          address: ModelAddress(
            title: addressName.text.trim(),
            address: address.text.trim(),
            city: city.text.trim(),
            landmark: landMark.text.trim(),
            phone: number.text.trim(),
          ),
        ));
        updating = false;
      }).catchError((e){
        updating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fireStoreService.getAddress().then((value) {
        if(value != null){
          addressName.text = value.title.toString();
          number.text = value.phone.toString();
          city.text = value.city.toString();
          address.text = value.address.toString();
          landMark.text = value.landmark.toString();
        }
        apiLoaded = true;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Address',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18
          ),),
      ),
      body: apiLoaded ?
      SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Your address to continue'.capitalize!,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(fontSize: 18, color: Colors.blue,fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12,),
              Lottie.asset(
                "assets/images/delivery.json",
                height: 160.0,
                repeat: true,
                reverse: true,
                animate: true,
              ),
              const SizedBox(height: 18,),
              buildTextField(
                  hintetxt: 'Enter Location Name',
                  icon: const Icon(
                    Icons.near_me,
                    color: Colors.blue,
                  ),
                  controller: addressName,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return "Please enter address name";
                    }
                    return null;
                  }
              ),
              const SizedBox(
                height: 20,
              ),
              buildTextField(
                  hintetxt: 'Enter Your Phone Number',
                  controller: number,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return "Please enter phone no.".capitalize;
                    }
                    if(value.trim().length < 10){
                      return "Please enter valid phone no.".capitalize;
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.blue,
                  )),
              const SizedBox(
                height: 20,
              ),
              buildTextField(
                  hintetxt: 'City',
                  controller: city,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return "Please your city".capitalize;
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.location_city_rounded,
                    color: Colors.blue,
                  )),
              const SizedBox(
                height: 20,
              ),
              buildTextField(
                  hintetxt: 'Address(Area and Street)',
                  keyboardType: TextInputType.streetAddress,
                  controller: address,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return "Please Enter Address";
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.blue,
                  )),
              const SizedBox(
                height: 20,
              ),
              buildTextField(
                  hintetxt: 'Nearby Landmark',
                  keyboardType: TextInputType.streetAddress,
                  controller: landMark,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return "Please Enter Nearby Landmark";
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.blue,
                  )),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: (){
                  updateAddress();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.blue),
                  child: const Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ) : const LoadingAnimation(),
    );
  }
}
