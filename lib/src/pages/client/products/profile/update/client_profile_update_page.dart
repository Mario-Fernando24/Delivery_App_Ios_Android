
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/profile/update/client_profile_update_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class ClientProfileUpdatePage extends StatefulWidget {

  @override
  _ClientProfileUpdatePageState createState() => _ClientProfileUpdatePageState();
}

class _ClientProfileUpdatePageState extends State<ClientProfileUpdatePage> {
   ClientProfileUpdateController _clientProfileUpdateController = Get.put(ClientProfileUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _imageCover(context),
        _buttonBack()
      ],
      ),
    );
  }

  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: ()=>Get.back(), 
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios,
          size: 30,),
        ),
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

Widget _imageCover(BuildContext context){
  return  SafeArea(
    child: Container(
      margin: EdgeInsets.only(top:30 ),
      alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: ()=>_clientProfileUpdateController.showAlertDialog(context),
          //control de estado setState se reemplaza por este GetBuilder<RegisterController>
          child: GetBuilder<ClientProfileUpdateController>(
            builder: (value)=>CircleAvatar(
            backgroundImage:
              _clientProfileUpdateController.imageFile!=null?
               FileImage(_clientProfileUpdateController.imageFile!)  :
               _clientProfileUpdateController.user.image!=null? 
                NetworkImage(_clientProfileUpdateController.user.image!)
               :AssetImage('assets/img/profile.png') as ImageProvider,
              // as ImageProvider le hacemos un casteo
            radius: 85,
            backgroundColor: Colors.white,
            ),), 
        ),
        ),
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
          _textApellido(),
          _textTelefono(),
          _buttonUpdate(context)
        ],
      ),
    ),
  );
}

Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text("Actualiza tus datos",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientProfileUpdateController.nameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Nombre',
        prefixIcon: Icon(Icons.person)
      ),
     ),
   );
}

Widget _textApellido(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientProfileUpdateController.lastnameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Apellido',
        prefixIcon: Icon(Icons.person)
      ),
     ),
   );
}

Widget _textTelefono(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientProfileUpdateController.phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Telefono',
        prefixIcon: Icon(Icons.phone)
      ),
     ),
   );
}

Widget _buttonUpdate(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: ElevatedButton(
      onPressed: ()=>_clientProfileUpdateController.updateProfile(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Actualizar",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}
}