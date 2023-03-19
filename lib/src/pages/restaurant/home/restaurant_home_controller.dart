import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/providers/push_notification_providers.dart';

class RestaurantHomeController extends GetxController{
  
   //instanciar las notificaciones push
   PushNotificacionProviders pushNotificacionProviders = PushNotificacionProviders();
   User user = User.fromJson(GetStorage().read('user') ?? {});
   
   //PARA SABER EN QUE POSICION DEL BOTTONBAR ESTAMOS UBICADOS
   var indexTab=0.obs;

   RestaurantHomeController(){
      saveToken();
   }


   void changeTam(int index){
    indexTab.value =index;
   }
   
   void singOut(){
    GetStorage().remove('user');
    //eliminando el historial de pantalla
    Get.offNamedUntil('/', (route) => false);
   }

  void saveToken(){
    if(user.id!=null){
      pushNotificacionProviders.saveToken(user.id!);
    }
  }

   
}