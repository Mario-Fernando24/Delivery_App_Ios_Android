import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_controller.dart';

class ClientOrdersController extends GetxController{
   

      //obtengo a todos los metodos de ese controlador
   ClientProductsListController clientProductsListController = Get.find();

   var selectProducts =<Product>[].obs;
   //para obtener el valor total type double
   var total=0.0.obs;
    //obtengo en el constructor los producto guardados en el GetStorage y lo almaceno en una lista de producto
     ClientOrdersController(){
     
       if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
            //le asigno el array que esta en el Gestorage y se lo asigno a la variable result
            var result =GetStorage().read('bolsa_compra'); 
            print("*********************************************************************");
            // print("mario fernando"+result);
            print("*********************************************************************");
            // vacio la lista de producto
            selectProducts.clear();
            // agrego los producto del result a la list de produto donde estan todos los productos que escogio el usuario
            selectProducts.addAll(result);
          
          }else{
            var result =Product.fromJsonList(GetStorage().read('bolsa_compra'));
            selectProducts.clear();
            selectProducts.addAll(result);
       }
       getTotal();
      
      }
    }



 
     // metodo  el cual recibe el producto como parametro para ir agregando producto de 1 en 1
     void addItem(Product product){
      //saber el indice para saber 
         int index=selectProducts.indexWhere((productt) => productt.id==product.id);
         selectProducts.remove(product);
         //cada ves que presionemos en el + se actualizara el producto que esta en ese indice
         product.quantity= product.quantity! + 1;
         //le agregamos a ese indice y el producto
         selectProducts.insert(index, product);
         //llamamos al GetStorage para guardar el json de producto en el storage
         GetStorage().write('bolsa_compra', selectProducts);
         getTotal();

            clientProductsListController.item.value=0;
             selectProducts.forEach((p) {
              clientProductsListController.item.value=clientProductsListController.item.value+(p.quantity!);
             });
    }


    
     // metodo  el cual recibe el producto como parametro para ir quitando producto de 1 en 1
     void removeItem(Product product){
      print("mario fernando ");

      if(product.quantity!>1){
      //saber el indice para saber 
         int index=selectProducts.indexWhere((productt) => productt.id==product.id);
         selectProducts.remove(product);
         //cada ves que presionemos en el + se actualizara el producto que esta en ese indice
         product.quantity= product.quantity! - 1;
         //le agregamos a ese indice y el producto
         selectProducts.insert(index, product);
         //llamamos al GetStorage para guardar el json de producto en el storage
         GetStorage().write('bolsa_compra', selectProducts);
         getTotal();
          
          
              clientProductsListController.item.value=0;

             selectProducts.forEach((p) {
              clientProductsListController.item.value=clientProductsListController.item.value+(p.quantity!);
             });

         }
    }


    void deleteProduct(Product product){
      selectProducts.remove(product);
      GetStorage().write('bolsa_compra', selectProducts);
      getTotal();
      if(selectProducts.length==0){
          clientProductsListController.item.value=0;
      }else{
          clientProductsListController.item.value=0;
          selectProducts.forEach((p) {
          clientProductsListController.item.value=clientProductsListController.item.value+(p.quantity!);
          });
      }
     
    }

    void getTotal(){
      total.value=0.0;
      var i=0;
         selectProducts.forEach((product) {
          
         i=i+1;
         
         if(i>1){
             total.value+=total.value+(product.quantity! * product.price!);

         }
      });
    }

    void goToListAddres(){
      Get.toNamed(ROUTES.listarAddres);
    }

}