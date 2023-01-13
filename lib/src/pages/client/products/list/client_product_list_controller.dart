import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/detail/client_product_list_detail_page.dart';
import 'package:ios/src/providers/categories_providers.dart';
import 'package:ios/src/providers/products_providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController{
  
    List<Category> categoriess =<Category>[].obs;
    
    CategoryProviders categoryProviders = CategoryProviders();
    ProductsProviders productsProviders = ProductsProviders();
    //buscar producto 
    var productName=''.obs;
    Timer? searchOnStoppedTyping;

   
      var item =0.obs;
      List<Product> selectProducts =[];

      //inicializo la funcion en el constructor
       ClientProductsListController() {

    
      if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
         selectProducts=GetStorage().read('bolsa_compra');
       }else{
          selectProducts=Product.fromJsonList(GetStorage().read('bolsa_compra'));
       }
          item.value=0;
          selectProducts.forEach((p) {
              item.value=item.value+(p.quantity!);
          });
     }

          getCategories();
        }


        void goToOrdersCreate(){
          Get.toNamed('/client/products/orders');
        }
           
        //texto digitado por el usuario para buscar por nombre
        void onChangeText(String text){

              const duration = Duration(milliseconds: 800);
              if (searchOnStoppedTyping != null) {
                searchOnStoppedTyping?.cancel();
              }

              searchOnStoppedTyping = Timer(duration, () {
                productName.value = text;
                print('TEXTO COMPLETO: ${text}');
              });

            

        }
        //listar todas las categorias
        void getCategories() async{
          var result = await categoryProviders.getAllCategory();
          categoriess.clear();
          categoriess.addAll(result);

        }


        Future<List<Product>> getProducts(String idcategory, String productName) async{
            if(productName.isEmpty){
                return await productsProviders.findByProductWithCategory(idcategory);
            }else{
                return await productsProviders.findByProductSearch(idcategory,productName);
            }  
        }


        //METODO PARA ABRIR EL BOTONSHEET DE LOS DETALLES DE LOS PRODUCTO
        void openBottonSheet(Product product, BuildContext context){
              showMaterialModalBottomSheet(
                context: context,
                //la pagina que quiero abrir
                builder: (contex)=>ClientProductDetailPage(
                  product: product)
                );
        }


   
}