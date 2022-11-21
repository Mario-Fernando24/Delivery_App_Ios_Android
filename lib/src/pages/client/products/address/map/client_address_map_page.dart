import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ios/src/pages/client/products/address/map/client_address_map_controller.dart';

class ClientAddresMapPage extends StatelessWidget {

   ClientAddresMapController _clientAddresMapController = Get.put(ClientAddresMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Ubica tu dirección en el mapa',
        style: TextStyle(color: Colors.black)),
      ),
      body: Stack(children: [
        _googleMaps(),
        iconMapLocation(),
        carAdrresDirection(),
        Spacer(),
        buttonSelect(context)
      ]),
    ));
  }

  Widget _googleMaps(){
    //retornamos googlemap de flutter
    return GoogleMap(
      //Inicia camera donde estara la posicion inicial
      initialCameraPosition: _clientAddresMapController.inicialPosition,
      //tipo de mapa
      mapType: MapType.normal,
      onMapCreated: _clientAddresMapController.onMapCreate,
      //crea un pequeño punto azul
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position){
        _clientAddresMapController.inicialPosition =position;
      },
      onCameraIdle: ()async{
         //llamamos a nuestro controlador cada vez que movamos el marcador se este actualizando
         await _clientAddresMapController.setLocationDraggableInfo();
      },
      
      );
  }


  Widget carAdrresDirection(){
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(''+_clientAddresMapController.addessName.value,style: TextStyle(color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold),),
          ),
      ),
    );
  }

  Widget iconMapLocation(){
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Center(
          child:  Image.asset('assets/img/my_location.png',
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  Widget buttonSelect(BuildContext context){
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(10),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        child: Text('SELECCIONAR ESTE PUNTO',style: TextStyle(
          color: Colors.black,
        ),),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.all(15)
        ),
        onPressed: ()=> _clientAddresMapController.seleccionarPuntoReferencia(context),
    
        ),
    );
  }

}