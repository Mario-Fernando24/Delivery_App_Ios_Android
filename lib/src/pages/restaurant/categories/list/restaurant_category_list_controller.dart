import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/pages/restaurant/categories/list/modal.dart';
import 'package:ios/src/providers/categories_providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  
}