import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/users_providers.dart';

class LoginController extends GetxController{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //instanciamos nuestra clase
    UsersProviders usersProviders = UsersProviders();
        User userModelo = User();


  void goToRegisterPage(){
    Get.toNamed("/register");
  }

  void goToHomePage(){
      //Get.offNamedUntil('/home', (route) => false);
      Get.offNamedUntil('/roles', (route) => false);
   }

  void goToRolesPage(){
      Get.offNamedUntil('/roles', (route) => false);
   }

  void goToClientHomePage(String route){
       Get.offNamedUntil(route, (route) => false);
   }

 void goToDomiciliarioHomePage(String route){
  Get.offNamedUntil(route, (route) => false);
 }

 void goToRestauranteHomePage(String route){
    Get.offNamedUntil(route, (route) => false);

 }


  void login() async{
       String email = emailController.text.trim();
       String password = passwordController.text.trim();

        if(isValidFormularioLogin(email, password)){
               ResponseApi responseApi= await  usersProviders.login(email, password);

               if(responseApi.success==true){
              //guardamos los datos del usuario y el token
                GetStorage().write('user', responseApi.data);
                   //  Get.snackbar("Login exitoso",responseApi.message ?? '');
                   //  si tiene mas de un rol que lo mande a la pantalla de los roles
                   if(responseApi.data["roles"].length>1){
                      goToRolesPage();
                    }else if(responseApi.data["roles"][0]['name']=='CLIENTE'){
                      //si tiene un solo rol que lo mande a client
                     goToClientHomePage(responseApi.data["roles"][0]['route']);
                    }
                    else if(responseApi.data["roles"][0]['name']=='REPARTIDOR'){
                      //si tiene un solo rol que lo mande a client
                     goToDomiciliarioHomePage(responseApi.data["roles"][0]['route']);
                    }
                    else if(responseApi.data["roles"][0]['name']=='RESTAURANTE'){
                      //si tiene un solo rol que lo mande a client
                     goToRestauranteHomePage(responseApi.data["roles"][0]['route']);
                    }
               }else{
                     Get.snackbar("Login fallido",responseApi.message ?? '');
               }  
                

        }

  }


  bool isValidFormularioLogin(String email, String password){
    if(email.isEmpty){    
       Get.snackbar("Formulario no valido","Debes ingresar el email");
      return false;
    }else if(password.isEmpty){
       Get.snackbar("Formulario no valido","Debes ingresar una contraseña");
       return false;
    }
    //valido con GetUtils si el campo email no es un correo 
    if(!GetUtils.isEmail(email)){
       Get.snackbar("Formulario no valido","Debes ingresar un correo electronico valido");
     return false;
    }
    return true;
  }

}