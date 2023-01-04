import 'package:get/get.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/providers/orders_providers.dart';

class RestaurantOdersListController extends GetxController{

   OrdersProviders ordersProviders =  OrdersProviders();

   List<String> status = <String> ['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  // llamar la listas de las orden por status
  Future<List<Order>> getOrders(String status)async{

       return await ordersProviders.findByStatus(status);
       
  }

  void goToDetailOrden(Order order){
       Get.toNamed(ROUTES.restaurant_orders_detail, arguments: {
      'order': order.toJson()
     });
  }
  
}