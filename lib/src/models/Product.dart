// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {

    String? id;
    String? name;
    String? description;
    double? price;
    String? image1;
    String? image2;
    String? image3;
    String? idCategory;
    int? quantity;



    Product({
        this.id,
        this.name,
        this.description,
        this.price,
        this.image1,
        this.image2,
        this.image3,
        this.idCategory,
        this.quantity,
    });

 
    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        idCategory: json["id_category"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "id_category": idCategory,
        "quantity": quantity,
    };


     //hacemos un metodo  que nos ayude a transformar  un array de objeto a una lista de category
    static List<Product> fromJsonList(List<dynamic> jsonList){
    
      List<Product> toList =[];
      jsonList.forEach((item) {
     
           Product product =Product.fromJson(item);
           //agregamos a la lista
           toList.add(product);
       });
       return toList;
    }

 
}
