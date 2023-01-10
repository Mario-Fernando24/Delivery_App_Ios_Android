import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ios/src/pages/client/products/address/map/client_address_map_controller.dart';
import 'package:ios/src/pages/delivery/orders/map/delivery_orders_map_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class DeliveryOrderMapPage extends StatelessWidget {

   DeliveryOrderMapController _deliveryOrderMapController = Get.put(DeliveryOrderMapController());

  @override
  Widget build(BuildContext context) {
    return Obx((() =>   Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.black),
      //   title: Text('Ubica tu dirección en el mapa',
      //   style: TextStyle(color: Colors.black)),
      // ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height*0.6,
          child: _googleMaps()
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonBack(),
                    _iconCenterMyLocation(),
                  ],
                ),
                Spacer(),
                _cardOrderInfo(context)
              ],
            ),
          ),
          // iconMapLocation(),
        //  carAdrresDirection(),
        // Spacer(),
      ]),
    )));
  }

  Widget _googleMaps(){
    //retornamos googlemap de flutter
    return GoogleMap(
      //Inicia camera donde estara la posicion inicial
      initialCameraPosition: _deliveryOrderMapController.inicialPosition,
      //tipo de mapa
      mapType: MapType.normal,
      onMapCreated: _deliveryOrderMapController.onMapCreate,
      //crea un pequeño punto azul
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
       markers: Set<Marker>.of(_deliveryOrderMapController.markers.values),

     
      
      );
  }

   Widget _buttonBack(){
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: ()=>Get.back(), 
          color: miTemaPrincipal,
          icon: Icon(Icons.arrow_back_ios,
          size: 30,),
        ),
      
    );
  }


  Widget _cardOrderInfo(BuildContext context){

     return Container(
      height: MediaQuery.of(context).size.height*0.4,
      width: double.infinity,
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
         ),
         boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,3)
          )
         ]
      ),

      child: SingleChildScrollView(
        child: Column(
          children: [
             _listTitleAddres(_deliveryOrderMapController.order.direccion_json?.direccion ?? '', 'Dirección',Icons.my_location),
             _listTitleAddres(_deliveryOrderMapController.order.direccion_json?.nombreBarrio ?? '', 'Barrio',Icons.location_on),
             Divider(color: Colors.black, endIndent: 30.0,indent: 30.0),
             infoClient(),
             buttonEntregarPedido(context)
          ],
        ),
      ),
     );
  }

  Widget _iconCenterMyLocation(){
      
      return GestureDetector(
        onTap: (){},
        child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            shape: CircleBorder(),
            color: Colors.white,
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.location_searching,
                color: Colors.grey[600],
                size: 20.0,
              ),
            ),
          ),
        ),
      );
     
  }

  Widget _listTitleAddres(String title, String subtitle, IconData iconData){
     
     return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: Text(title,
          style: TextStyle(
          fontSize: 13.0
        ),
       ),
       subtitle: Text(subtitle),
       trailing: Icon(iconData),

      ),
     );

  }

  Widget infoClient(){
     
     return Container(
      margin: EdgeInsets.only(top: 1.0, right: 33.0,left: 33.0),
      child: Row(
        children: [
            _imageClient(),
            nameClient(),
            buttonLlamada()
        ],
      ),
     );
  }

   Widget _imageClient(){

        return Container(
              height: 70,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FadeInImage(
                  image: _deliveryOrderMapController.order.cliente_json?.image!=null ?
                  NetworkImage(_deliveryOrderMapController.order.cliente_json?.image ?? '')
                  : AssetImage('assets/img/no-image.png') as ImageProvider,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  //en caso de que no venga ninguna imagen
                  placeholder: AssetImage('assets/img/no-image.png'), 
                  ),
              ),
            );
     }


     Widget nameClient(){

       return Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Text('${_deliveryOrderMapController.order.cliente_json?.name ?? ''} ${_deliveryOrderMapController.order.cliente_json?.lastname ?? ''} '),
       );
     }

     Widget buttonLlamada(){
        
        return  Container(
              margin: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0)),
                  color: Colors.grey[200]
              ),
              child: IconButton(
            onPressed: (){},
             icon: Icon(Icons.phone, color: Colors.black,)),
            );

     }



  // Widget carAdrresDirection(){
  //   return Container(
  //     width: double.infinity,
  //     alignment: Alignment.topCenter,
  //     margin: EdgeInsets.symmetric(vertical: 30),
  //     child: Card(
  //       color: Colors.grey[800],
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20)),
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           child: Text(''+_deliveryOrderMapController.addessName.value,style: TextStyle(color: Colors.white,
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold),),
  //         ),
  //     ),
  //   );
  // }

  // Widget iconMapLocation(){
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 40),
  //     child: Center(
  //         child:  Image.asset('assets/img/my_location.png',
  //         width: 60,
  //         height: 60,
  //       ),
  //     ),
  //   );
  // }

  Widget buttonEntregarPedido(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      margin: EdgeInsets.only(left: 30.0, right: 30.0),
      child: ElevatedButton(
        child: Text('ENTREGAR PEDIDO',style: TextStyle(
          color: Colors.black,
        ),),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.all(15)
        ),
        onPressed: ()=> _deliveryOrderMapController.seleccionarPuntoReferencia(context),
    
        ),
    );
  }

}