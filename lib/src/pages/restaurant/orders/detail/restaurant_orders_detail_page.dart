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

class RestaurantOdersDetailController extends GetxController{

  //recibo por parametro el json de las orders
  Order order = Order.fromJson(Get.arguments['order']);
   var total=0.0.obs;
  //para saber el id del domiciliario que el usuario selecciono
  var id_usuario=''.obs;
  List<User> usuarioDomiciliario =<User>[].obs;
  UsersProviders _usersProviders = UsersProviders();
  OrdersProviders _ordersProviders= OrdersProviders();

  //contructor
  RestaurantOdersDetailController(){
    print('Order: ${order.toJson()}');
    getTotal();
    getUsuarioDomiciliario();
  }

//listar todas los domiciliario (usuario)
  void getUsuarioDomiciliario() async{
    var result = await _usersProviders.getAllDomiciliario();
    usuarioDomiciliario.clear();
    usuarioDomiciliario.addAll(result);
  }

  
    void getTotal(){
      total.value=0.0;
      //recorremos la lista con un for
         order.produc!.forEach((product) {
         total.value+=total.value+(product.quantity! * product.price!);
      });
    }

   void updateOrdenDespachada(id_orden, BuildContext context) async{
         ProgressDialog progressDialog = ProgressDialog(context: context);
      if(id_usuario!=''){
          Order order = Order(
            id: id_orden,
            idDomiciliario: id_usuario.toString(),);
         progressDialog.show(max: 100, msg: "Espere un momento...");
          
     ResponseApi responseApi = await _ordersProviders.updateOrdersDespachada(order);

     if(responseApi.success==true){
          progressDialog.close();
        Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
        Get.offNamedUntil('/restaurant/home', (route) => false);
      
     }
     }else{
      Get.snackbar('Petición denegada', 'Debes asiganar un domiciliario');
     }
      
     

       
     
   }


}