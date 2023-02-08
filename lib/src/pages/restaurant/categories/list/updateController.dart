import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/categories_providers.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../../../models/Category.dart';

class UpdateController extends GetxController{


  CategoryProviders categoryProviders = CategoryProviders();


  


     void updateCategory(TextEditingController name, TextEditingController descripcion, String id, BuildContext context) async{
            
            String nameC=name.text.trim();
            String descriptionC=descripcion.text.trim();
       
            ProgressDialog progressDialog = ProgressDialog(context: context);
            progressDialog.show(max: 100, msg: "actualizando categoria...");

            if(!nameC.isEmpty && !descriptionC.isEmpty){
              
              Category cate = Category(
                id:id,
                name:nameC,
                descripcion: descriptionC
              );
              
              ResponseApi responseApi= await categoryProviders.updateCategory(cate);

              if(responseApi.success==true){
                    progressDialog.close();
                    Get.snackbar('Proceso terminado correctamente', responseApi.message ?? '');
                    goToHomeRestaurante(context);
              }

              print('excelente mario ferrnando${nameC}');

            }else{
                progressDialog.close();
            }

   }    


     void goToHomeRestaurante(BuildContext context){
        Get.toNamed('/restaurant/home');
  }  


    
  }
