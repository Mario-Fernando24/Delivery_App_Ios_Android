import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/address/list/client_addres_list_controller.dart';

//LISTA DE DIRECCIONES DE LOS CLIENTES DONDE SE LE VAN A ENVIAR LOS PEDIDOS
class ClientAddresListPage extends StatelessWidget {
 
    ClientAddresListController _clientAddresListController = Get.put(ClientAddresListController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Mis Direcciones',style: TextStyle(color: Colors.black),),
        actions: [iconAddresClient()],
      ),
    );
  }

  Widget iconAddresClient(){
     return IconButton(
      onPressed: ()=>_clientAddresListController.goToAddresCreate(),
      icon: Icon(
        Icons.add,color: Colors.black)
      );
  }
}