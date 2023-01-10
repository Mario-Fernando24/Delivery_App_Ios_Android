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

    //creamos un mapa de valores para el marcador personalizado
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
    BitmapDescriptor? domiciliarioMarcador;
    BitmapDescriptor? homeMarcador;



  //creamos nuestro constructor
  DeliveryOrderMapController(){
     print('Order=======> mapaaa: ${order.toJson()}');

    //para que se pinte los marcadores como desde la casa donde ira el domiciliario como la posicion de el 

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
          domiciliarioMarcador = await createMarcadorDeLosAsset('assets/img/delivery_mini.png');
          homeMarcador = await createMarcadorDeLosAsset('assets/img/my_location_mini.png');

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
        //añade los marcadores personalizados
        addMarker('Domiciliario', position?.latitude ?? 0.0, position?.longitude ?? 0.0, 'Tu posición', '', domiciliarioMarcador! );
        addMarker('Cliente', order.direccion_json?.lat ?? 0.0, order.direccion_json?.lng ?? 0.0, 'Lugar de entrega', '', homeMarcador! );

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


    Future<BitmapDescriptor> createMarcadorDeLosAsset(String url) async{
        
        ImageConfiguration configuration = ImageConfiguration();
        BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, url);

        return descriptor;


    }


    //marcador personalizado
    void addMarker(
      String markeId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
    ){
       MarkerId id = MarkerId(markeId);
       Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
        );
 
        markers[id] = marker;
    }


}
