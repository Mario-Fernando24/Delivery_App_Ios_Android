import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/User.dart';

class ClientProfileInfoController extends GetxController{

 //Listar la informacion del usuario que esta logueado
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;

   void singOut(){
    GetStorage().remove('user');
    //eliminando el historial de pantalla
    Get.offNamedUntil('/', (route) => false);
   }

   void goToUpdateProfile(){
    Get.toNamed('/client/profile/update');
   }

   
   void goToRoles(){
    Get.toNamed('/roles');
   }

    void showAlertDialog(context){

      Widget closed = ElevatedButton(
        onPressed: (){
         singOut();
        }, 
        child: Text("SI", style: TextStyle(color: Colors.black))
        );

      Widget noClosed = ElevatedButton(
        onPressed: (){
                    Get.back();

        }, 
        child: Text("NO", style: TextStyle(color: Colors.black))
        );

        AlertDialog alertDialog = AlertDialog(
          title: Text('Desea salir de la App'),
          actions: [
            closed,
            noClosed
          ],
        );

        showDialog(context: context, builder: (BuildContext context){
          return alertDialog;
        });
    }


}