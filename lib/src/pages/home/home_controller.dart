import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/User.dart';

class HomeController extends GetxController{

   //que me retorne el dato user que esta guardado en el storage del telefono
   User user = User.fromJson(GetStorage().read('user') ?? {});

   HomeController(){
    print('USUARIO DE SESIÓN: ${user.toJson()}');
   }

    //cerramos la session eliminando al usuario del storage 
   void singOut(){
    GetStorage().remove('user');
    //eliminando el historial de pantalla
    Get.offNamedUntil('/', (route) => false);
   }


  

}