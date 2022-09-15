
 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/profile/update/client_profile_update_controller.dart';
import 'package:ios/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class RestaurantCategoriesCreatePage extends StatefulWidget {

  @override
  _RestaurantCategoriesCreatePageState createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {
   RestaurantCategoriesCreateController _restaurantCategoriesCreateController = Get.put(RestaurantCategoriesCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _textNewCategory(context)
      ],
      ),
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
      margin: EdgeInsets.only(top:16 ),
      alignment: Alignment.topCenter,
        child: Column(
          children: [
          Icon(Icons.category,size: 100,),
          Text("NUEVA CATEGORIA",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
          ])
    )
  );
}

Widget _boxForm(BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.34, left: 30, right: 30),
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
    height: MediaQuery.of(context).size.height*0.60,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textYourInfo(),
          _textName(),
          _textDescription(),
          _buttonUpdate(context)
        ],
      ),
    ),
  );
}

Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text("Agregar categoria",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _restaurantCategoriesCreateController.nameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Categoria',
        prefixIcon: Icon(Icons.category)
      ),
     ),
   );
}

Widget _textDescription(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
     child: TextField(
      controller: _restaurantCategoriesCreateController.descripctionController,
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
      onPressed: ()=> _restaurantCategoriesCreateController.createCategory(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Crear categoria",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}
}
