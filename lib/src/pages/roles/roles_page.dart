import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Rol.dart';
import 'package:ios/src/pages/roles/roles_controller.dart';

class RolesPage extends StatelessWidget {

   RolesController rolesController = Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccione el rol",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.10),
        child: ListView(
          children: 
           rolesController.user.roles!=null? rolesController.user.roles!.map((Rol rol) {
              return carRol(rol);
            }).toList() : [],
        ),
      ),
    );
  }


  Widget carRol(Rol rol){
       return GestureDetector(
        onTap: ()=> rolesController.goToPageRol(rol),
         child: Column(
          children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                height: 100,
                child: FadeInImage(
                  image: NetworkImage(rol.image!),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/profile.png'),
                ),
              ),
       
              Text(rol.name ?? '',style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ),)
          ],
         ),
       );
  }
}