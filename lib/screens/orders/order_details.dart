import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/helper/new_helper.dart';

import '../../model/order_details.dart';
import '../check_out/check_out_screen.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key, required this.modelOrderDetails});
  final ModelOrderDetails modelOrderDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
                itemCount: modelOrderDetails.productsList!.length,
                itemBuilder: (context, index) {
                  final productDetails = modelOrderDetails.productsList![index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x3600000F),
                                  offset: Offset(0, 2),
                                )
                              ], borderRadius: BorderRadius.circular(21), color: Colors.white),
                              child: Image.network(
                                productDetails.productDetails!.imageUrl!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productDetails.productDetails!.name.toString(),
                                    style:
                                        const TextStyle(fontSize: 15, color: Colors.teal, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${productDetails.productQuantity}x${productDetails.productDetails!.price}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(productDetails.productDetails!.price.toString().toNum * productDetails.productQuantity.toString().toNum).toStringAsFixed(2)} Rs",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: addressCard(address: modelOrderDetails.address!, ordersDetails: true),
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      if (modelOrderDetails.paymentMethod != null) ...[
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                child: Text(
                              "Payment Method:",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            )),
                            Text(
                              modelOrderDetails.paymentMethod,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                                "Transaction ID:",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                              )),
                          Text(
                            modelOrderDetails.transactionId,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Shipping:",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          )),
                          Text(
                            modelOrderDetails.shipping.toString() == "0"
                                ? "Free Shipping!"
                                : "${modelOrderDetails.shipping.toString()} Rs",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: modelOrderDetails.shipping.toString() == "0"
                                    ? Colors.greenAccent.shade700
                                    : Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Subtotal:",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          )),
                          Text(
                            "${(modelOrderDetails.totalAmount.toString().toNum - modelOrderDetails.shipping.toString().toNum).toStringAsFixed(2)} Rs",
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Total:",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          )),
                          Text(
                            "${modelOrderDetails.totalAmount.toString()} Rs",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
