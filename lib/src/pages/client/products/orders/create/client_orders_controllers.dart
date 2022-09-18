import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Product.dart';

class ClientOrdersController extends GetxController{
   
   List<Product> selectProducts =[];
  
    //obtengo en el constructor los producto guardados en el GetStorage y lo almaceno en una lista de producto
     ClientOrdersController(){
     
       if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
         selectProducts=GetStorage().read('bolsa_compra');
       }else{
          selectProducts=Product.fromJsonList(GetStorage().read('bolsa_compra'));
       }
      
      }
    }

}