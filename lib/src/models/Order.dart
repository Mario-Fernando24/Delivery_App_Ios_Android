 // To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
   

    String ?id;
    String ?idClient;
    String ?idDomiciliario;
    String ?idDireccion;
    double ?lat;
    double ?lng;
    String ?statu;
    int ?timetamp;
    //creamos una lista de producto para enviarle al backe los productos de la orden 
    List<Product> ?produc = [];
    //creamos una lista de usuario del servicio de orders
    User? cliente_json;
    User? domiciliario_json;
    Address? direccion_json;

    Order({
        this.id,
        this.idClient,
        this.idDomiciliario,
        this.idDireccion,
        this.lat,
        this.lng,
        this.statu,
        this.timetamp,
        this.produc,
        this.cliente_json,
        this.domiciliario_json,
        this.direccion_json
    });



    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        idClient: json["id_client"],
        idDomiciliario: json["id_domiciliario"],
        idDireccion: json["id_direccion"],
        lat: json["lat"],
        lng: json["lng"],
        statu: json["statu"],
        timetamp: json["timetamp"],
        //validamos si la data no llega tipo json o null
         produc: json["produc"] != null ? List<Product>.from(json["produc"].map((model) => model is Product ? model : Product.fromJson(model))) : [],
        //preguntamos si viene como un string si no preguntamos si es de tipo users
        cliente_json: json["cliente_json"] is String ? userFromJson(json["cliente_json"]) : json["cliente_json"] is User ? json["cliente_json"] : User.fromJson(json["cliente_json"] ?? {}),
        domiciliario_json: json["domiciliario_json"] is String ? userFromJson(json["domiciliario_json"]) : json["domiciliario_json"] is User ? json["domiciliario_json"] : User.fromJson(json["domiciliario_json"] ?? {}),
        direccion_json: json["direccion_json"] is String ? addressFromJson(json["direccion_json"]) : json["direccion_json"] is Address ? json["direccion_json"] : Address.fromJson(json["direccion_json"] ?? {}),


    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "id_domiciliario": idDomiciliario,
        "id_direccion": idDireccion,
        "lat": lat,
        "lng": lng,
        "statu": statu,
        "timetamp": timetamp,
        "produc": produc,
        "cliente_json": cliente_json,
        "domiciliario_json": domiciliario_json,
        "direccion_json": direccion_json,
    };


    static List<Order> fromJsonList(List<dynamic> jsonList){
     
      List<Order> toList =[];

      jsonList.forEach((item) {
  
           Order orders =Order.fromJson(item);
           toList.add(orders);
       });

       return toList;
    }
}
