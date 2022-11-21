import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/login/login_controller.dart';
import 'package:ios/src/providers/users_providers.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class RegisterController extends GetxController{

    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController repitpasswordController = TextEditingController();

    //instanciamos nuestra clase
    UsersProviders usersProviders = UsersProviders();
    //
    ImagePicker picker = ImagePicker();
    //escoger .io
    File? imageFile;
    LoginController loginController = LoginController();


 void goToClientProductPage() {
    Get.offNamedUntil('/client/products/list', (route) => false);
  }

    void register(BuildContext context) async{
      String email = emailController.text.trim();
      String name = nameController.text.trim();
      String lastname = lastnameController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();
      String repPassword = repitpasswordController.text.trim(); 

      if(isValidRegister(email, name, lastname, phone, password, repPassword)){


      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: "Registrando los datos...");
        //creamos un usuario
        User user = User(
          email:email,
          name:name,
          lastname:lastname,
          phone:phone,
          passwordd:password
        );

          
    Stream stream = await usersProviders.createWithImage(user, imageFile!);
      stream.listen((res) {

        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data); // DATOS DEL USUARIO EN SESION
          goToClientProductPage();
        }
        else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }

      });
       //  Stream stream = await usersProviders.createWithImage(user, imageFile!);
     

        //  Response response = await usersProviders.registerUser(user);
        
        //  if(response.body['success']){
        //      Get.snackbar("Excelente","${response.body['message']}");
        //  }else{         
        //      Get.snackbar("Advertencia","${response.body['message']}");
        //  }
             

      }
     
    }



    bool isValidRegister(String email, String name, String lastname, String phone, String password, String repPassword){

        if(email.isEmpty){    
        Get.snackbar("Formulario no valido","Debes ingresar el email");
         return false;
        }

        if(!GetUtils.isEmail(email)){
          Get.snackbar("Formulario no valido","Debes ingresar un correo electronico valido");
        return false;
        }

        if(name.isEmpty){
          Get.snackbar("Formulario no valido","Debes ingresar nombre");
        return false;
        }

        if(lastname.isEmpty){
          Get.snackbar("Formulario no valido","Debes ingresar Apellido");
        return false;
        }

         if(phone.isEmpty){
          Get.snackbar("Formulario no valido","Debes ingresar Telefono");
        return false;
        }
        if(phone[0]!="3"){
            Get.snackbar("Formulario no valido", "No es un numero de telefono valido");
            return false;      
        }

        if(password.isEmpty){
          Get.snackbar("Formulario no valido","Debes ingresar una contraseña");
        return false;
        }

        if(password!=repPassword){
            Get.snackbar("Formulario no valido","Contraseña no coinciden");
        return false;
        }

         if(imageFile==null){
            Get.snackbar("Formulario no valido","Debes agregar una imagen de perfil");
        return false;
        }

        return true;

    }


    //funcion para escoger el uso de la camara o la galeria del dispositio
    void showAlertDialog(BuildContext context){

      Widget galleryButton = ElevatedButton(
        onPressed: (){
          Get.back();
          //abrimos la galeria
          selectImage(ImageSource.gallery);
        }, 
        child: Text("Galeria", style: TextStyle(color: Colors.black))
        );

      Widget cameraButton = ElevatedButton(
        onPressed: (){
          Get.back();
          //abrimos la camara del dispositivo
          selectImage(ImageSource.camera);
        }, 
        child: Text("Camara", style: TextStyle(color: Colors.black))
        );

        AlertDialog alertDialog = AlertDialog(
          title: Text('Selecciona una opción'),
          actions: [
            galleryButton,
            cameraButton
          ],
        );

        showDialog(context: context, builder: (BuildContext context){
          return alertDialog;
        });
    }


   //
   Future selectImage(ImageSource imageSource) async{

     XFile? imagen = await picker.pickImage(source: imageSource);
     if(imagen!=null){
      //le paso la ruta de la imagen
      imageFile = File(imagen.path);
      //actualizamos
      update();

     }
   }
}