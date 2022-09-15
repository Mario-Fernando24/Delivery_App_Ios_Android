import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Rol.dart';
import 'package:ios/src/models/User.dart';

class RolesController extends GetxController{

      //traer los roles asignados de ese usuario
     User user = User.fromJson(GetStorage().read('user') ?? {});
 
    //funcion para enviar la ruta de los roles
    void goToPageRol(Rol rol){
       print("mariooooo${rol.route}");
      // Get.offNamedUntil(rol.route??'', (route) => false);
      Get.toNamed(rol.route??'');   
    }
} 