import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/client/products/address/map/client_address_map_page.dart';
import 'package:ios/src/providers/address_providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddresCreateController extends GetxController{

    TextEditingController addressController = TextEditingController();
    TextEditingController nombreBarrioController = TextEditingController();
    TextEditingController puntoReferenciaController = TextEditingController();
    AddressProviders addressProviders = AddressProviders();

    //me permite utilizar todo los metodos de ese controlador
    //ClientAddresCreateController clientAddresCreateController = Get.find();

    double latitud=0.0;
    double longitud=0.0;

  void goToGoogleMap(BuildContext context)async{

    //nos devuelve un mapa
    Map<String,dynamic> refPositionMap= await showMaterialModalBottomSheet(
      context: context,
       builder: (context)=>ClientAddresMapPage(),
       isDismissible: false,
       enableDrag: false
       );
       latitud=refPositionMap['lat'];
       longitud=refPositionMap['lng'];

       puntoReferenciaController.text=refPositionMap['address'];
       print('referencia del mapa${refPositionMap['address']}');

       print('sssssssssssssssssssssssssssssssssssssssssssssssssssssss');
       print(latitud);
       print(longitud);
       print('sssssssssssssssssssssssssssssssssssssssssssssssssssssss');
  }

  void createAddress() async{
  
     String addressName=addressController.text.toString();
     String nombreBarrio = nombreBarrioController.text.toString();
     String puntoReferencia = puntoReferenciaController.text.toString();
     if(isValidateAddres(addressName, nombreBarrio, puntoReferencia)){
      
      Address addresss = Address(
        direccion:addressName,
        nombreBarrio:nombreBarrio,
        lat: latitud,
        lng: longitud
      );

      ResponseApi responseApi = await addressProviders.createAddress(addresss);
      
         toaShow("Mensaje", responseApi.message ?? '',2);
         clearForm();

        // Get.back();
        if(responseApi.success==true){
          addresss.id=responseApi.data;
          GetStorage().write('direccion',addresss.toJson());
          // clientAddresCreateController.update();
          Get.toNamed(ROUTES.listarAddres);
        }

     }
     
   
  }


  bool isValidateAddres(String addressName,String nombreBarrio,String puntoReferencia){
    if(addressName.isEmpty){

       toaShow('Formulario no valido', 'Ingresa el nombre de la dirección',1);
    
      return false;

    }
    if(nombreBarrio.isEmpty){
       toaShow('Formulario no valido', 'Ingresa el nombre del barrio',1);

      return false;

    }
    if(puntoReferencia.isEmpty){
       toaShow('Formulario no valido', 'Ingresa referencia en el mapa',1);
       return false;

    }

    return true;
  }

   void clearForm(){
        addressController.text='';
        nombreBarrioController.text='';
        puntoReferenciaController.text='';
    }

    void toaShow(String title,String subtitle, int numero){
       Get.snackbar(
          title,
          subtitle,
          icon: Icon(
          numero==1? Icons.warning: Icons.check, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: numero==1? Color.fromARGB(255, 255, 65, 40) : Colors.green,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.bounceInOut,
        ); 
   } 


}
