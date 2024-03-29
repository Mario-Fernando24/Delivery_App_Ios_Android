// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {

    String ?id;
    String ?direccion;
    String ?nombreBarrio;
    double ?lat;
    double ?lng;
    String ?idUsers;


    Address({
        this.id,
        this.direccion,
        this.nombreBarrio,
        this.lat,
        this.lng,
        this.idUsers,
    });

   

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        direccion: json["direccion"],
        nombreBarrio: json["nombreBarrio"],
        lat: json["lat"],
        lng: json["lng"],
        idUsers: json["id_users"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "direccion": direccion,
        "nombreBarrio": nombreBarrio,
        "lat": lat,
        "lng": lng,
        "id_users": idUsers,
    };


     static List<Address> fromJsonList(List<dynamic> jsonList){
     
      List<Address> toList =[];
      jsonList.forEach((item) {
        
        
       

        Address address = Address.fromJson(item);
  
           toList.add(address);
       });

       return toList;

    }

}  

