import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_controller.dart';
import 'package:ios/src/pages/providers/users_providers.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController{

      User user = User.fromJson(GetStorage().read('user') ?? {});

    TextEditingController nameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

     ImagePicker picker = ImagePicker();
    //escoger .io
    File? imageFile;
    UsersProviders usersProviders = UsersProviders();

    //para acceder a todos los metodos y atributo que tenga este controller
    ClientProfileInfoController clientProfileInfoController =Get.find();

   //creamos nuestro constructor
   ClientProfileUpdateController(){
    nameController.text=user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
   }


   void updateProfile(BuildContext context) async{

      String name = nameController.text.trim();
      String lastname = lastnameController.text.trim();
      String phone = phoneController.text.trim();

        if(isValidUpdate(name, lastname, phone)){
            print("mario fernando muñoz rivera");

           ProgressDialog progressDialog = ProgressDialog(context: context);
           progressDialog.show(max: 100, msg: "Actualizando los datos...");
           //creamos un usuario
            User myuser = User(
              id: user.id,
              name:name,
              lastname:lastname,
              phone:phone
            );

            if(imageFile==null){
             
              ResponseApi responseApi= await usersProviders.updateUserProfileSinImagenes(myuser); 
              
              
               
                Get.snackbar('Proceso terminado', responseApi.message ?? '');
                progressDialog.close();
               
                if (responseApi.success == true) {
                GetStorage().write('user', responseApi.data);
                print(responseApi.data);

                clientProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
                
                }else{               
                Get.snackbar("Mensaje", responseApi.message!);
               
                } 


            }else{

              //ACTUALIZAR PERFIL CON IMAGENES
              Stream stream = await usersProviders.updateWithImage(myuser,imageFile!); 
              stream.listen((res) {
              
              progressDialog.close();
              ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
              Get.snackbar('Proceso terminado', responseApi.message ?? '');
              if (responseApi.success == true) {
                GetStorage().write('user', responseApi.data);
                clientProfileInfoController.user.value = User.fromJson(GetStorage().read('user') ?? {});
              }
              else {
                Get.snackbar('Registro fallido', responseApi.message ?? '');
              }
            
                
               });
            
            }
            
        }

      }



    bool isValidUpdate(String name, String lastname, String phone){

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