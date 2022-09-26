import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Product.dart';

class ClientOrdersController extends GetxController{
   
   List<Product> selectProducts =<Product >[].obs;
   var counter=0.obs;
    //obtengo en el constructor los producto guardados en el GetStorage y lo almaceno en una lista de producto
     ClientOrdersController(){
     
       if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
            //le asigno el array que esta en el Gestorage y se lo asigno a la variable result
            var result =GetStorage().read('bolsa_compra'); 
            // vacio la lista de producto
            selectProducts.clear();
            // agrego los producto del result a la list de produto donde estan todos los productos que escogio el usuario
            selectProducts.add(result);
          
          }else{
            var result =Product.fromJsonList(GetStorage().read('bolsa_compra'));
            selectProducts.clear();
            selectProducts.addAll(result);
       }
      
      }
    }


    void addItem(Product product){
      //saber el indice
         int index=selectProducts.indexWhere((productt) => productt.id==product.id);

    }

}