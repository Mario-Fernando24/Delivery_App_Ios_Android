import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/detail/client_product_list_detail_page.dart';
import 'package:ios/src/pages/providers/categories_providers.dart';
import 'package:ios/src/pages/providers/products_providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController{
  
    List<Category> categoriess =<Category>[].obs;
    CategoryProviders categoryProviders = CategoryProviders();
    ProductsProviders productsProviders = ProductsProviders();

      //inicializo la funcion en el constructor
       ClientProductsListController() {
          getCategories();
        }

        void goToOrdersCreate(){
          Get.toNamed('/client/products/orders/create');
        }

        //listar todas las categorias
        void getCategories() async{
          var result = await categoryProviders.getAllCategory();
          categoriess.clear();
          categoriess.addAll(result);

        }


        Future<List<Product>> getProducts(String idcategory) async{
           return await productsProviders.findByProductWithCategory(idcategory);
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