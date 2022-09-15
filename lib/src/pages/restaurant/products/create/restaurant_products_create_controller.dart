import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/pages/providers/categories_providers.dart';
import 'package:ios/src/pages/providers/products_providers.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class RestaurantProductsCreateController extends GetxController{

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  
  TextEditingController descripctionController = TextEditingController();
  CategoryProviders categoryProviders = CategoryProviders();

  ImagePicker picker = ImagePicker();
  //escoger .io
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  //para saber el id de la categoria que el usuario selecciono
  var idCategoria=''.obs;
  List<Category> categoriess =<Category>[].obs;
  ProductsProviders productsProviders = ProductsProviders();

  //inicializo la funcion en el constructor
    RestaurantProductsCreateController() {
        getCategories();
      }

//listar todas las categorias
  void getCategories() async{
    var result = await categoryProviders.getAllCategory();
    categoriess.clear();
    categoriess.addAll(result);

  }

  
  void createProduct(BuildContext context) async{
      String nameProduct = nameController.text.trim();
      String descriptionProduct = descripctionController.text.trim();
      String price = priceController.text;

      
      if(isValidProduct(nameProduct, descriptionProduct,price)){
        
        ProgressDialog progressDialog = ProgressDialog(context: context);
           //creamos una categoria
           Product myNewProducts = Product(
              name:nameProduct,
              description: descriptionProduct,
              price:double.parse(price),
              idCategory: idCategoria.value,
            );

            progressDialog.show(max: 100, msg: "Espere un momento...");
            //creamos nuestra lista de imagenes
            List<File> filesImage=[];
            filesImage.add(imageFile1!);
            filesImage.add(imageFile2!);
            filesImage.add(imageFile3!);

            Stream stream = await productsProviders.createProductsWithImg(myNewProducts, filesImage);
            stream.listen((res) {

                  progressDialog.close();

                  ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

                  if (responseApi.success == true) {
                    clearForm();
                    Get.snackbar('Proceso terminado', responseApi.message ?? '');
                  }
                  else {
                    Get.snackbar('Registro fallido', responseApi.message ?? '');
                  }

                });

             


      }
  }

  bool isValidProduct(String nameProduct, String descriptionProduct,String price){

        if(nameProduct.isEmpty){    
          Get.snackbar("Por favor","Debes ingresar un producto");
          return false;
        }
        if(descriptionProduct.isEmpty){
            Get.snackbar("Por favor","Debes ingresar una descripción del producto");
            return false;
        }
        if(price.isEmpty){
            Get.snackbar("Por favor","Debes ingresar un precio del producto");
            return false;
        }
        if(idCategoria.value==''){
           Get.snackbar("Por favor","Debes seleccionar una categoria");
            return false;
        }
        if(imageFile1==null){
           Get.snackbar("Por favor","Primera Imagen es obligatoria");
            return false;
        }
        if(imageFile2==null){
           Get.snackbar("Por favor","Segunda Imagen es obligatoria");
            return false;
        }
        if(imageFile3==null){
           Get.snackbar("Por favor","Tercera Imagen es obligatoria");
            return false;
        }
        return true;

    }

    void clearForm(){
       nameController.text='';
       descripctionController.text='';
       priceController.text='';
       imageFile1=null;
       imageFile2=null;
       imageFile3=null;
       idCategoria.value='';
       update();
    }



     //funcion para escoger el uso de la camara o la galeria del dispositio
    void showAlertDialog(BuildContext context,int numberFile){

      Widget galleryButton = ElevatedButton(
        onPressed: (){
        
          //abrimos la galeria
          selectImage(ImageSource.gallery,numberFile);
            Get.back();
        }, 
        child: Text("Galeria", style: TextStyle(color: Colors.black))
        );

      Widget cameraButton = ElevatedButton(
        onPressed: (){
          Get.back();
          //abrimos la camara del dispositivo
          selectImage(ImageSource.camera,numberFile);
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
   Future selectImage(ImageSource imageSource, int numberFile) async{

     XFile? imagen = await picker.pickImage(source: imageSource);
     if(imagen!=null){
      
      if(numberFile==1){
          //le paso la ruta de la imagen
          imageFile1 = File(imagen.path);
      }
      else if(numberFile==2){
          //le paso la ruta de la imagen
          imageFile2 = File(imagen.path);
      }
      else if(numberFile==3){
          //le paso la ruta de la imagen
          imageFile3 = File(imagen.path);
      }
       update();
     }


}
}