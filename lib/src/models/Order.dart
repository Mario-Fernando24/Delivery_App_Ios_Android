 // To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:ios/src/models/Product.dart';

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
    List<Product> ?products = [];

    Order({
        this.id,
        this.idClient,
        this.idDomiciliario,
        this.idDireccion,
        this.lat,
        this.lng,
        this.statu,
        this.timetamp,
        this.products
    });



    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        idClient: json["id_client"],
        idDomiciliario: json["id_domiciliario"],
        idDireccion: json["id_direccion"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        statu: json["statu"],
        timetamp: json["timetamp"],
        products: json["products"],
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
        "products": products,

    };
}
