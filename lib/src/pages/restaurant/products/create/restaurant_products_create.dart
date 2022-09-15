
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class RestaurantProductoCreatePage extends StatefulWidget {

  @override
  _RestaurantProductoCreatePageState createState() => _RestaurantProductoCreatePageState();
}

class _RestaurantProductoCreatePageState extends State<RestaurantProductoCreatePage> {
   RestaurantProductsCreateController _restaurantProductsCreateController = Get.put(RestaurantProductsCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(() => Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _textNewCategory(context)
      ],
      ),
      )
    );
  }


Widget _backgruoundCover(BuildContext context){
   return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height*0.4,
    color: miTemaPrincipal,
   );
}

Widget _textNewCategory(BuildContext context){
  return  SafeArea(
    child: Container(
      margin: EdgeInsets.only(top:25 ),
      alignment: Alignment.topCenter,
        child: 
          Text("NUEVA PRODUCTO",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
          
    )
  );
}

Widget _boxForm(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height*0.7,
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.18, left: 30, right: 30),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black54,
          blurRadius: 15,
          offset: Offset(0.0,75)
        )
      ]
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textYourInfo(),
          _textName(),
          _textDescription(),
          _textPrice(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<RestaurantProductsCreateController>(
                    builder: (value)=>  
                    cardImage(context, _restaurantProductsCreateController.imageFile1, 1)),

                    SizedBox(width:5),
                    GetBuilder<RestaurantProductsCreateController>(
                    builder: (value)=>  
                    cardImage(context, _restaurantProductsCreateController.imageFile2, 2)),
                    SizedBox(width:5),

                     GetBuilder<RestaurantProductsCreateController>(
                    builder: (value)=>  
                    cardImage(context, _restaurantProductsCreateController.imageFile3, 3)),


                    ],
            ),
          ),
           _dropDownCategories(_restaurantProductsCreateController.categoriess),
          _buttonUpdate(context)
        ],
      ),
    ),
  );
}

Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text("Agregar producto",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _restaurantProductsCreateController.nameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Nombre',
        prefixIcon: Icon(Icons.category)
      ),
     ),
   );
}


Widget _textPrice(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _restaurantProductsCreateController.priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Precio',
        prefixIcon: Icon(Icons.attach_money)
      ),
     ),
   );
}

Widget _textDescription(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
     child: TextField(
      controller: _restaurantProductsCreateController.descripctionController,
      keyboardType: TextInputType.text,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Descripción',
        prefixIcon: Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Icon(Icons.description)
          )
      ),
     ),
   );
}


Widget _buttonUpdate(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
    child: ElevatedButton(
      onPressed: ()=> _restaurantProductsCreateController.createProduct(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Crear producto",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}

//Widget que nos permita mostrar las categorias



  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar categoria',
          style: TextStyle(

            fontSize: 15
          ),
        ),
        items: _dropdownMenuItem(categories),
        value: _restaurantProductsCreateController.idCategoria.value == '' ? null : _restaurantProductsCreateController.idCategoria.value,
        onChanged: (option) {
          print('Opcion seleccionada ${option}');
          _restaurantProductsCreateController.idCategoria.value = option.toString();
        },
      ),
    );
  }

List<DropdownMenuItem<String>> _dropdownMenuItem(List<Category> categories){
  List<DropdownMenuItem<String>> list =[];
  categories.forEach((category) {
         list.add(DropdownMenuItem(
          child: Text(category.name ?? ''),
          value: category.id,
          ));
   });

   return list;
}
//recibe dos parametro
//el archivo
//numero entero que nos dice cual es el numero de la imagen
Widget cardImage(BuildContext context,File? imageFile,int numberFile){

  return GestureDetector(
        onTap: ()=>_restaurantProductsCreateController.showAlertDialog(context, numberFile),
        child:  Card(
        elevation: 3,
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width*0.2,
          child: imageFile!=null? 
            Image.file(
              imageFile,
              fit: BoxFit.cover,
            )
          :
          Image(
            image:  AssetImage('assets/img/no-image.png'),
          )
        ),   
      ),
  );

}
}
