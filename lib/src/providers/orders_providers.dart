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



  //  Future<List<Category>> getAllCategory() async {
     
  //    Response response = await get(
  //       '$url/getAllCategory',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': userSesion.session_token ?? ''
  //       }
  //   ); 
    
  //   if(response.statusCode==401){
  //       Get.snackbar("Error", "No tiene permisos");
  //       return [];
  //   }
  //   List<Category> categories =Category.fromJsonList(response.body);
  //   return categories;
  // }

 Future<ResponseApi> createOrders(order) async {


  // print('lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
  //       print(order.idClient);
  //       print(order.idDireccion);
  //       print(order.products);

  //     order.products?.forEach((subItem) {
  //       print(subItem.name);
  //     });
        

  // print('ñññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññññ');

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


  

  

}