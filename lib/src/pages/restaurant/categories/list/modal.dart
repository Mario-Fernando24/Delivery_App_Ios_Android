import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/pages/restaurant/categories/list/restaurant_category_list_controller.dart';

class ModalCategory extends StatelessWidget {
  
  Category? category;
   late RestaurantCategoryListController restaurantCategoryListController;

    ModalCategory({@required this.category}){
      restaurantCategoryListController = Get.put(RestaurantCategoryListController());
     }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
            _textYourInfo(),
            _textName(),
            _textDescription(),
            _buttonEdit(context)
        ],
      ),
    );
  }

  Widget _textYourInfo(){
    return Container(
      margin: EdgeInsets.only(top: 30,bottom: 30),
      child: Text("Agregar categoria",
      style: TextStyle(color: Colors.black,fontSize: 18,
      fontWeight: FontWeight.bold),));
  }

  Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      // controller: _restaurantCategoriesCreateController.nameController,
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
      // controller: _restaurantCategoriesCreateController.descripctionController,
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


  Widget _buttonEdit(BuildContext context){
  return Container(
    width: double.infinity,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: ElevatedButton(
      onPressed: ()=>{},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Editar",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}


}