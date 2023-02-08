import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/pages/restaurant/categories/list/restaurant_category_list_controller.dart';
import 'package:ios/src/pages/restaurant/categories/list/updateController.dart';

class UpdateCategory extends StatefulWidget {
  UpdateCategory({Key? key}) : super(key: key);

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
   UpdateController updateController = Get.put(UpdateController());
     Category categorypa = Category.fromJson(Get.arguments['categoryy']);

    final  TextEditingController nameController = TextEditingController();
    final  TextEditingController descripctionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

      nameController.text=categorypa.name.toString();
      descripctionController.text=categorypa.descripcion.toString();

    
       return Scaffold(
        bottomNavigationBar: _buttonEdit(context),
        appBar: AppBar(
          title: Text('Actualizar categoria'),
        ),
         body: Container(
             child: Column(
          children: [
              _textYourInfo('Editar  '),
              _textName(),
              _textDescription(),
          ],
         ),
        ),
       );
  }

  Widget _textYourInfo(String name){
    return Container(
      margin: EdgeInsets.only(top: 30,bottom: 30),
      child: Text(name+nameController.text,
      style: TextStyle(color: Colors.black,fontSize: 20,
      fontWeight: FontWeight.bold),));
  }

  Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
        controller: nameController,
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
      controller: descripctionController,
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
       onPressed: ()=>updateController.updateCategory(nameController, descripctionController,categorypa.id.toString(), context),

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