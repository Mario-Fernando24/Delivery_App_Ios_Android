import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryHomeController extends GetxController{
  

   //PARA SABER EN QUE POSICION DEL BOTTONBAR ESTAMOS UBICADOS
   var indexTab=0.obs;


   void changeTam(int index){
    indexTab.value =index;
   }
   
   void singOut(){
    GetStorage().remove('user');
    //eliminando el historial de pantalla
    Get.offNamedUntil('/', (route) => false);
   }

   
}