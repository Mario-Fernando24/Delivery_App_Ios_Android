// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {


    String ?direccion;
    String ?nombreBarrio;
    double ?lat;
    double ?lng;
    int ?idUsers;


    Address({
        this.direccion,
        this.nombreBarrio,
        this.lat,
        this.lng,
        this.idUsers,
    });



    factory Address.fromJson(Map<String, dynamic> json) => Address(
        direccion: json["direccion"],
        nombreBarrio: json["nombre_barrio"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        idUsers: json["id_users"],
    );

    Map<String, dynamic> toJson() => {
        "direccion": direccion,
        "nombre_barrio": nombreBarrio,
        "lat": lat,
        "lng": lng,
        "id_users": idUsers,
    };
}
