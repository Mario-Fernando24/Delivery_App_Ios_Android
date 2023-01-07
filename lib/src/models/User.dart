import 'dart:convert';

import 'package:ios/src/models/Rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

  String? id; //NULL SAFETY https://app.quicktype.io/
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? passwordd;
  String? session_token;
  //creamos una list de roles de arreglos vacios
  List<Rol>? roles = [];

  //constructor
  User({
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.phone,
    this.image,
    this.passwordd,
    this.session_token,
    this.roles
  });


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"].toString(),
    email: json["email"],
    name: json["name"],
    lastname: json["lastname"],
    phone: json["phone"],
    image: json["image"],
    passwordd: json["passwordd"],
    session_token: json["session_token"],
    //hacemos unas validaciones en el caso de que venga nulo
    roles: json["roles"] == null ? [] : List<Rol>.from(json["roles"].map((model) => Rol.fromJson(model))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "lastname": lastname,
    "phone": phone,
    "image": image,
    "passwordd": passwordd,
    "session_token": session_token,
    "roles": roles
  };


    static List<User> fromJsonList(List<dynamic> jsonList){
    
      List<User> toList =[];
      jsonList.forEach((item) {
     
           User users =User.fromJson(item);
           toList.add(users);
       });
       return toList;
    }
}
