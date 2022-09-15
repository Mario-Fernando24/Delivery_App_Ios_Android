import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/providers/categories_providers.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class RestaurantCategoriesCreateController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController descripctionController = TextEditingController();
  CategoryProviders categoryProviders = CategoryProviders();


  void createCategory(BuildContext context) async{
      String nameCategory = nameController.text.trim();
      String descriptionCategory = descripctionController.text.trim();
      
      if(isValidCategory(nameCategory, descriptionCategory)){
        
        ProgressDialog progressDialog = ProgressDialog(context: context);
        progressDialog.show(max: 100, msg: "Registrando categoria...");
           //creamos una categoria
            Category myNewCategory = Category(
              name:nameCategory,
              descripcion: descriptionCategory
            );

              ResponseApi responseApi= await categoryProviders.createCategory(myNewCategory); 
                progressDialog.close();
               
                if (responseApi.success == true) {
                clearForm();
                print(responseApi.data);
                Get.snackbar('Proceso terminado', responseApi.message ?? '');
                
                }else{               
                Get.snackbar("Error", responseApi.message!);
               
                } 


      }else{
      }
  }

  bool isValidCategory(String nameCategory, String descriptionCategory){

        if(nameCategory.isEmpty){    
          Get.snackbar("Por favor","Debes ingresar una categoria");
          return false;
        }
        if(descriptionCategory.isEmpty){
            Get.snackbar("Por favor","Debes ingresar una descripción de la categoria");
            return false;
        }
        return true;

    }

    void clearForm(){
       nameController.text='';
       descripctionController.text='';
    }


}
