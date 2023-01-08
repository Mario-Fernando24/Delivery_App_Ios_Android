import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class OrdersProviders extends GetConnect{
  
  String url = Environment.API_URL +'api/orders';
  User userSesion = User.fromJson(GetStorage().read('user') ?? {});



    Future<List<Order>> findByStatus(String status) async {

    
      Response response = await get(
         '$url/findByStatus/'+status,
         headers: {
           'Content-Type': 'application/json',
           'Authorization': userSesion.session_token ?? ''
         }
     ); 

   
    
     if(response.statusCode==401){
         Get.snackbar("Error", "No tiene permisos");
         return [];
     }

     List<Order> orderss = Order.fromJsonList(response.body);
     return orderss;
   }



    //Listar la lista de ordenes del usuario
    Future<List<Order>> findByStatusDomiciliario(String id_domiciliario,String status) async {

    
      Response response = await get(
         '$url/findByDeliveryIdStatus/'+id_domiciliario+'/'+status,
         headers: {
           'Content-Type': 'application/json',
           'Authorization': userSesion.session_token ?? ''
         }
     ); 
    
     if(response.statusCode==401){
         Get.snackbar("Error", "No tiene permisos");
         return [];
     }

     List<Order> orderss = Order.fromJsonList(response.body);
     return orderss;
   }





 Future<ResponseApi> createOrders(order) async {


    Response response = await post(
        '$url/create',
        order.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSesion.session_token ?? ''
        }
    );
    
    //si la respuesta nos trae null muestro este snackbar
    print(response);
    if(response.body==null){
      Get.snackbar("Error", "Hubo un error interno, por favor intentar mas tarde");
      //retorno vacio
      return ResponseApi();
    }
    //si no agrego al fromJson la respuesta y la retorno
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }



  Future<ResponseApi> updateOrdersDespachada(Order order) async {

      Response response = await put(
          '$url/updateToDespachado',
          order.toJson(),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userSesion.session_token ?? ''
          }
      ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    
      if(response.body==null){
      Get.snackbar("Error", "No se pudo despachar la orden, tuvo algun error");
        return ResponseApi();
      }
      if(response.statusCode==401){
        Get.snackbar("Error", "No esta autorizado para realizar este petición");
        return ResponseApi();
      }
      else{
          //creamos un objeto
          ResponseApi responseApi = ResponseApi.fromJson(response.body);
          return responseApi;

      }
    }





  

  

}