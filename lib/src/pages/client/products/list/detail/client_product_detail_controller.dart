import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_controller.dart';

class ClientProductsDetailController extends GetxController{  

   List<Product> selectProducts =[];
   
   //obtengo a todos los metodos de ese controlador
   ClientProductsListController clientProductsListController = Get.find();
    
   ClientProductsDetailController(){}
    
    void verificarIfProductAgregados(Product product, var price, var counter){

      price.value=product.price ?? 0;
       if(GetStorage().read(ROUTES.car_shop)!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read(ROUTES.car_shop) is List<Product>){
         selectProducts=GetStorage().read(ROUTES.car_shop);
       }else{
          selectProducts=Product.fromJsonList(GetStorage().read(ROUTES.car_shop));
       }

        //para saber si el producto ya fue agregado a la bolsa GESTORAJE
        int index=selectProducts.indexWhere((productt) => productt.id==product.id);
       

        if(index!=-1){ //el producto ya fue agregado
             counter.value = selectProducts[index].quantity ?? 0;
             price.value = product.price! * counter.value;
             selectProducts.forEach((element) {
           print(element.toJson());
          });
        }
         
     }
    }

      void addBolsa(Product product, var price, var counter){
      
       
      if(counter.value>0){

        int index=selectProducts.indexWhere((productt) => productt.id==product.id);

        if(index==-1){


           if(product.quantity==null){


            if(counter.value>0){
              print("entro 1");



              product.quantity=counter.value;
            }else{
                            print("entro 2");


              product.quantity=1;
            }
           }

                            print('8888888888888888888');

           print("mario fernando muñoz rivera"+product.toJson().toString());
           selectProducts.add(product);
           
        }else{

                                      print('99999999999999999');

             selectProducts[index].quantity=counter.value;
            //  print("=======================================================");
            //  print(selectProducts[index].toJson());
            //  print("=======================================================");
              }
              
               GetStorage().write(ROUTES.car_shop, selectProducts);
              toaShow("Producto agregado","correctamente",2); 
       
              clientProductsListController.item.value=0;

              selectProducts.forEach((p) {
              clientProductsListController.item.value=clientProductsListController.item.value+(p.quantity!);
             });

       }else{
        toaShow("Advertencia","debes seleccionar un item para agregarlo",1);  
            }

      }
   //para agregar un item
   void addItem(Product product, var price, var counter){
    print("PRODUCTO AGREGADO MARIO: ${product.toJson()} ");
    counter.value=counter.value+1;
    price.value=product.price!* counter.value;

   }
   //metodo para remover un item y actualizar el precio
    void removeItem(Product product, var price, var counter){
      if(counter.value>0){
        counter.value=counter.value-1;
        price.value=product.price!* counter.value;

      }


   }




   void toaShow(String title,String subtitle, int numero){
       Get.snackbar(
          title,
          subtitle,
          icon: Icon(
          numero==1? Icons.warning: Icons.check, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: numero==1? Colors.amber[400] : Colors.green,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.bounceInOut,
        ); 
   }
}
