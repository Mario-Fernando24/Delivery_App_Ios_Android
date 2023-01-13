import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/orders_providers.dart';
import 'package:ios/src/providers/users_providers.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientOdersDetailController extends GetxController{

  //recibo por parametro el json de las orders
  Order order = Order.fromJson(Get.arguments['order']);
   var total=0.0.obs;
  //para saber el id del domiciliario que el usuario selecciono
  var id_usuario=''.obs;
  UsersProviders _usersProviders = UsersProviders();
  OrdersProviders _ordersProviders= OrdersProviders();

  //contructor
  ClientOdersDetailController(){
    print('Order=======> clienteeeeeeeeeeeeeeeeeeeeee: ${order.toJson()}');
    getTotal();
  }

    void getTotal(){
      total.value=0.0;
      //recorremos la lista con un for
         order.produc!.forEach((product) {
         total.value+=total.value+(product.quantity! * product.price!);
      });
    }

   void updateOrdenIniciarEntrega(id_orden, BuildContext context) async{
         ProgressDialog progressDialog = ProgressDialog(context: context);
          Order orderrr = Order(id: id_orden);
         progressDialog.show(max: 100, msg: "Iniciandno entrega...");
          
     ResponseApi responseApi = await _ordersProviders.updateOrdersIniciandoEntrega(orderrr);

     if(responseApi.success==true){
          progressDialog.close();
        Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
        Get.toNamed('/delivery/orders/map',arguments: {
          'order':order.toJson()
        });
     }else{
        progressDialog.close();
        Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
     }
   
   }

   void goToMapOrders(){

    Get.toNamed('/client/orders/map',arguments: {
          'order':order.toJson()
        });
   }


}