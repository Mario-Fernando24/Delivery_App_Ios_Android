import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/providers/orders_providers.dart';

class ClientOdersPedidoListController extends GetxController{

   OrdersProviders ordersProviders =  OrdersProviders();
  User userSesion = User.fromJson(GetStorage().read('user') ?? {});

   List<String> status = <String> ['PAGADO','DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  // llamar la listas de las orden por status
  Future<List<Order>> getOrders(String status)async{
  print(status);

       return await ordersProviders.findByStatusClient(userSesion.id.toString() ?? '0',status);
       
  }

  void goToDetailOrden(Order order){
       Get.toNamed(ROUTES.client_orders_detail, arguments: {
      'order': order.toJson()
     });
  }
  
}