import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/orders/create/client_orders_controllers.dart';


class ClientOrdersPage extends StatelessWidget {
  
   ClientOrdersController _clientOrdersController= Get.put(ClientOrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('pantalla de la orden'),
      ),
    );
  }
}