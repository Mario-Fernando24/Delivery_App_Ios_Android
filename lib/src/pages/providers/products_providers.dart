import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class ProductsProviders extends GetConnect{
  
  String url = Environment.API_URL +'api/product';
  User userSesion = User.fromJson(GetStorage().read('user') ?? {});



  //ME RETORNA UNA LISTA DE PRODUCTO, LE ENVIO POR PARAMETRO EL ID DE LA CATEGORIA
    Future<List<Product>> findByProductWithCategory(String idcategory) async {
      
      // print("::::::::::::::::::::::::::::::::::::::");
      // print(idcategory);
      // print(":::::::::::::::::::::::::::::::::::::::");
      Response response = await get(
          '$url/findByProducts/$idcategory',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userSesion.session_token ?? ''
          }
      ); 

      
      if(response.statusCode==401){
          Get.snackbar("Error", "No tiene permisos");
          return [];
      }
      List<Product> products =Product.fromJsonList(response.body);
      return products;
      
    }



  //METODO PARA GAURDAR UN PRODUCTO CON LAS 3 IMAGENES
  //recibimos por parametro un objeto de producto y una lista de imagenes
  Future<Stream> createProductsWithImg(Product product, List<File> image) async {
    final uri = Uri.parse(url+'/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = userSesion.session_token ?? '';

    //
    for(int i=0;  i<image.length; i++){
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image[i].openRead().cast()),
          await image[i].length(),
          filename: basename(image[i].path)
        ));
    }


     //enviamos un producto
    request.fields['product'] = json.encode(product);

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }





}