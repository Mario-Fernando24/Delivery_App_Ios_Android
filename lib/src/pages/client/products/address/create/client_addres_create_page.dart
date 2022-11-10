import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/address/create/client_addres_create_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class ClientAddresCreatePage extends StatelessWidget {
   ClientAddresCreateController _clientAddresCreateController= Get.put(ClientAddresCreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      body:  Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _textNewDireccion(context),
        _icoBack(),
      ],
      ),
    );
  }

  Widget _icoBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 15.0),
        child: IconButton(
          onPressed: ()=>Get.back(),
          icon: Icon(Icons.arrow_back_ios,size: 30),
        ),
      )
    );
  }


  Widget _backgruoundCover(BuildContext context){
   return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height*0.3,
    color: miTemaPrincipal,
   );
}

Widget _textNewDireccion(BuildContext context){
  return  SafeArea(
    child: Container(
      margin: EdgeInsets.only(top:16 ),
      alignment: Alignment.topCenter,
        child: Column(
          children: [
          Icon(Icons.location_on,size: 100,),
          Text("NUEVA DIRECCIÓN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
          ])
    )
  );
}

Widget _boxForm(BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.29, left: 30, right: 30),
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
          _textAddress(),
          _textNombreBarrio(),
          _textPuntoReferencia(),
          SizedBox(height: 20),
          _buttonUpdate(context)
        ],
      ),
    ),
  );
}

Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text("Agregar dirección",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textAddress(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientAddresCreateController.addressController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Dirección',
        prefixIcon: Icon(Icons.location_on)
      ),
     ),
   );
}


Widget _textNombreBarrio(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientAddresCreateController.nombreBarrioController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Nombre del barrio',
        prefixIcon: Icon(Icons.location_city_sharp)
      ),
     ),
   );
}

Widget _textPuntoReferencia(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: _clientAddresCreateController.puntoReferenciaController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Punto de referencia',
        prefixIcon: Icon(Icons.map)
      ),
     ),
   );
}



Widget _buttonUpdate(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
    child: ElevatedButton(
      onPressed: ()=> (){},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Crear dirección",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}
}