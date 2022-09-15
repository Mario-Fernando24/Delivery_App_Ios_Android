import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';

class RestaurantOdersListPage extends StatelessWidget {
  
   RestaurantOdersListController restaurantOdersListController = Get.put(RestaurantOdersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: Text("Restaurant Orders List"),
       ),
    );
  }
}