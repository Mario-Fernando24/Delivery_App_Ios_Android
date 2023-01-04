import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ios/src/models/Order.dart';

class RestaurantOdersDetailController extends GetxController{

  //recibo por parametro el json de las orders
  Order order = Order.fromJson(Get.arguments['order']);
   var total=0.0.obs;

  //contructor
  RestaurantOdersDetailController(){
    print('Order: ${order.toJson()}');
    getTotal();
  }

  
    void getTotal(){
      total.value=0.0;
      //recorremos la lista con un for
         order.produc!.forEach((product) {
         total.value+=total.value+(product.quantity! * product.price!);
      });
    }

}