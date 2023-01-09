import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ios/src/models/Order.dart';
import 'package:location/location.dart' as location;
class DeliveryOrderMapController extends GetxController{

 //obtengo por parametro la orden 
  Order order = Order.fromJson(Get.arguments['order']);

  //para inicializar el mapa en una posicion inicial cercana
  CameraPosition inicialPosition = CameraPosition(
    target: LatLng(8.762816, -75.883065),
    zoom: 15
    );

   //viene de esta libreria dart:async
    Completer<GoogleMapController> mapController =Completer();
    Position? position;
    LatLng? addressLatLng;
    //declaramos un observable
    var addessName=''.obs;


  //creamos nuestro constructor
  DeliveryOrderMapController(){
    print('Order=======> mapaaa: ${order.toJson()}');
    verificarGPS();//EMPIECE A VERIFICAR SI EL GPS ESTA ACTIVO Y REQUERIR LOS PERMISO
  }

    //establecer el nombre de la direccion cuando arrastramos el map
    Future setLocationDraggableInfo() async{
         double lat =inicialPosition.target.latitude;
         double long =inicialPosition.target.longitude;

       
         List<Placemark> address = await placemarkFromCoordinates(lat, long);

         if(address.isNotEmpty){
            String direction = address[0].thoroughfare ?? '';   
            String calle = address[0].subThoroughfare ?? '';
            String city = address[0].locality ?? '';
            String departamento = address[0].administrativeArea ?? '';
            String country = address[0].country ?? '';

            addessName.value='$direction #$calle , $city, $departamento';
            addressLatLng=LatLng(lat, long);
         }

    }

    //verificar si el gps esta activado
    void verificarGPS()async{
       bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
       //si el gps esta activado actualizamos la localizacion
       if(isLocationEnable==true){
        updateLocation();
       }else{
        bool locationGPS = await location.Location().requestService();
        if(locationGPS==true){
          update();
        }
       }
    }

    void updateLocation() async{
     try{
        await _determinePosition();
        //ontenemos la longitud y latitud de nuestro dispositivo actual
        position =await Geolocator.getLastKnownPosition();
        animateCameraPosition(position!.latitude, position!.longitude);

     }catch(e){
      print('errorr==>>$e');
     }
 }
  
  //recibimos la lat and long
  Future animateCameraPosition(double lat, double lgt) async{
       GoogleMapController controller = await mapController.future;
       controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat,lgt),
        zoom: 14,
        bearing: 0
        ),
       ),
      );
  }

 
  Future<Position> _determinePosition() async {
   bool serviceEnabled;
   LocationPermission permission;
   serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  //nos devuelve un geolocator con la posicion actual donde nos encontramos
  return await Geolocator.getCurrentPosition();
}


    void onMapCreate(GoogleMapController controller){
      //inicializamos
      mapController.complete(controller);
    }

    //metodo seleccionar
    void seleccionarPuntoReferencia(BuildContext context){

      if(addressLatLng!=null){
        Map<String,dynamic> data = {
          'address': addessName.value,
          'lat':addressLatLng!.latitude,
          'lng':addressLatLng!.longitude
        };
        
       Navigator.pop(context,data);
      };

    }


}
