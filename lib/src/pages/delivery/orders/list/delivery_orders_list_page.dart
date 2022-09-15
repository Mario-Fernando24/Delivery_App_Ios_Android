import 'package:flutter/material.dart';
import 'package:ios/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:get/get.dart';

class DeliveryOdersListPage extends StatelessWidget {

   DeliveryOdersListController deliveryOdersListController = Get.put(DeliveryOdersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: Text("Delivery Orders List"),
       ),
    );
  }
}