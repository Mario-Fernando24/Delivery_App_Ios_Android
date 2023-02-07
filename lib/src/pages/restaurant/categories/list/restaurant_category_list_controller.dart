import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/restaurant/categories/list/modal.dart';
import 'package:ios/src/providers/categories_providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantCategoryListController extends GetxController{

  CategoryProviders categoryProviders = CategoryProviders();
  List<Category> category =<Category>[].obs;
   
  

  RestaurantCategoryListController(){
    //  getCategories();
  }

  Future<List<Category>> getCategories() async{

     category = await categoryProviders.getAllCategory();
     return category;
  }

   void openBottonSheetCategory(Category category, BuildContext context){

              showMaterialModalBottomSheet(
                context: context,
                builder: (contex)=>SizedBox(
                  height: MediaQuery.of(context).size.height*0.60,
                  child: ModalCategory(
                    category: category
                  ),
                )
                );
         }

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

   void goToHomeRestaurantCreate(){
       Get.toNamed('/restaurant/category/create');
  }  
   void goToHomeRestaurante(BuildContext context){
       getCategories();
       Navigator.pop(context);
  }  


 
}