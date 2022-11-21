import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AddressProviders extends GetConnect{
  
  String url = Environment.API_URL +'api/address';
  User userSesion = User.fromJson(GetStorage().read('user') ?? {});

 Future<ResponseApi> createAddress(Address address) async {
  
     
     Response response = await post(
        '$url/create',{
          'direccion': address.direccion,
          'nombreBarrio': address.nombreBarrio,
          'lat': address.lat,
          'lng': address.lng,
          'idUsers': userSesion.id

        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSesion.session_token ?? ''
        }
    ); 
    
    //si la respuesta nos trae null muestro este snackbar
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