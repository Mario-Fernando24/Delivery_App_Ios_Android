// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {

    String? id;
    String? name;
    String? descripcion;

        Category({
        this.id,
        this.name,
        this.descripcion,
      });


    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"].toString(),
        name: json["name"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "descripcion": descripcion,
    };

    //hacemos un metodo  que nos ayude a transformar  un array de objeto a una lista de category
    static List<Category> fromJsonList(List<dynamic> jsonList){
     
      List<Category> toList =[];

      jsonList.forEach((item) {
           Category category =Category.fromJson(item);
           //agregamos a la lista
           print('=========================================');
           print(category.toJson());
           
           print('=========================================');
           toList.add(category);
       });

       return toList;
    }
}
