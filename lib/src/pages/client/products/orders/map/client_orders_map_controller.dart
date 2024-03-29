import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/providers/orders_providers.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';
class ClientOrderMapController extends GetxController{

 //obtengo por parametro la orden 
  Order order = Order.fromJson(Get.arguments['order']);

  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
       'transports': ['websocket'],
       'autoConnect': false
  });

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

    //escuchar evento
    StreamSubscription? positionSubcription;

    //rutas
    Set<Polyline> polyline = <Polyline>{}.obs;
    List<LatLng> points = [];


    OrdersProviders ordersProviders = OrdersProviders();



  //creamos nuestro constructor
  ClientOrderMapController(){
    //  print('Order=======> mapaaa clienteeeeeeeeeeeeeea: ${order.toJson()}');
    //para que se pinte los marcadores como desde la casa donde ira el domiciliario como la posicion de el 
    verificarGPS();//EMPIECE A VERIFICAR SI EL GPS ESTA ACTIVO Y REQUERIR LOS PERMISO
    connectAndListen();
  }

   void connectAndListen(){
    //que se conecte a socket io
     socket.connect();
     //que empiece a escuchar los cambios
     socket.onConnect((data){
          print('ESTE DISPOSITIVO SE CONECTO A SOCKET IO cliente');
     }); 
     listenPosition();
     //escuchar algun evento del domiciliario
     listenToDomiciliario();
  }


  //escuchar los cambios
  void listenPosition(){
    //escuchamos los cambios en esa ruta que nos emite el backend
    socket.on('position/${order.id}', (data) => {
      //Nos regresa la data y llamamos la funcion addMarker para que se vuelva a redibuar en el mapa
        addMarker('Domiciliario', data['lat'] ?? 0.0, data['lng'] ?? 0.0, 'Tu Domiciliario', '', domiciliarioMarcador! ),         
    });
  }

  //escuchar el evento cuando un domiciliario presiono el boton de entregar para salir de la pantalla
  void listenToDomiciliario(){
    //escuchamos los cambios en esa ruta que nos emite el backend
    socket.on('delivered/${order.id}', (data) => {
         Fluttertoast.showToast(msg: "La orden se actualizo a entregado",toastLength: Toast.LENGTH_LONG),
        Get.offNamedUntil('/delivery/home', (route) => false),
    });
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
        update();
    }

    //verificar si el gps esta activado
    void verificarGPS()async{
          domiciliarioMarcador = await createMarcadorDeLosAsset('assets/img/delivery_mini.png');
          // homeMarcador = await createMarcadorDeLosAsset('assets/img/my_location_mini.png');
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

    //desde donde queremos trazar la ruta y hasta donde 
    Future<void> setPolylines(LatLng from, LatLng to)async{

      PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
      PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(Environment.API_KEY_MAP, pointFrom, pointTo);

     //recorremos la lista que nos trae result entre las dos puntos
      for(PointLatLng point in result.points){
        //agrego cada uno de los puntos
         points.add(LatLng(point.latitude, point.longitude));
      }

      //creamos un objeto polyline
      Polyline polylinee = Polyline(
        polylineId: PolylineId('poly'),
        //color con el que se trazara la ruta
        color: miTemaPrincipal,
        //los puntos que vamos a trazar
        points: points,
        //ancho de la ruta que se trazara
        width: 5
        );

        polyline.add(polylinee);
        update();

    }

    void updateLocation() async{
     try{
        await _determinePosition();
        //ontenemos la longitud y latitud de nuestro dispositivo actual
        position =await Geolocator.getLastKnownPosition();
        // saveLocationDomiciliarioLatLng();
        animateCameraPosition(order.lat ?? 0, order.lng ?? 0);
        //añade los marcadores personalizados
        addMarker('Domiciliario', order.lat ?? 0.0, order.lng ?? 0.0, 'Tu Domiciliario', '', domiciliarioMarcador! );
        addMarker('Cliente', order.direccion_json?.lat ?? 0.0, order.direccion_json?.lng ?? 0.0, 'Lugar de entrega', '', homeMarcador! );

        //agrego la varible latLng desde hasta
        LatLng from = LatLng(order.lat ?? 0,order.lng ?? 0);
        LatLng to = LatLng(order.direccion_json?.lat ?? 0.0, order.direccion_json?.lng ?? 0.0);
        //le paso las variable por parametro
        setPolylines(from, to);
     }catch(e){
      print('errorr==>>$e');
     }
 }

//  void saveLocationDomiciliarioLatLng()async{

//   if(position!=null){
//    order.lat=position!.latitude;
//    order.lng = position!.longitude;
//    await ordersProviders.updatePosicionDomiciliarioLatLng(order);
//   }



//  }
  
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


    //centrar la posicion actual del domiciliario
    void centerPosicion(){
      if(position!=null){
                Fluttertoast.showToast(msg: 'cargando posición...' ?? '', toastLength: Toast.LENGTH_LONG);

          animateCameraPosition( order.direccion_json?.lat ?? 0.0 ,  order.direccion_json?.lng ?? 0.0 );
      }
    }

    void callNumber() async{
    String number = order.domiciliario_json?.phone ?? ''; //set the number here
     await FlutterPhoneDirectCaller.callNumber(number);
}



    //dejar de escuchar
    @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    positionSubcription?.cancel(); 
     //cuando salimos de la pantalla le decimos al socket que se desconecte
    socket.disconnect();
  }




}
