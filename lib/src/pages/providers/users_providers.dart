import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class UsersProviders extends GetConnect{
  
  String url = Environment.API_URL +'api/users';
  User userSesion = User.fromJson(GetStorage().read('user') ?? {});


 Future<ResponseApi> login(String email, String passwordd) async {
     
     Response response = await post(
        '$url/login',{
          'email': email,
          'passwordd': passwordd
        },
        headers: {
          'Content-Type': 'application/json'
        }
    ); 
    
    //si la respuesta nos trae null muestro este snackbar
    if(response.body==null){
      Get.snackbar("Error", "Hubo un error interno, por favor intentar mas tarde");
      //retorno vacio
      return ResponseApi();
    }

    //si no agrego al fromJson la respuesta y la retorno
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Response> registerUser(User user) async {
     
     Response response = await post(
        '$url/create',
        user.toJson(),
        headers: {
          'Content-Type': 'application/json'
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    return response;
  }

  Future<Stream> createWithImage(User user, File image) async {
    final uri = Uri.parse(url+'/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    
    print("****************************************************");
    print(json.encode(user));
    print("****************************************************");

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }


  /*
  * GET X
   */
  Future<ResponseApi> createUserWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });
    Response response = await post('$url/createWithImage', form);

    if (response.body == null) {
      Get.snackbar('Error en la peticion', 'No se pudo crear el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }




  //METODO PARA ACTUALIZAR EL PERFIL DEL USUARIO SIN IMAGEN
  
  Future<ResponseApi> updateUserProfileSinImagenes(User user) async {
     
     print("_______________________________________________");
     print(user.name);
     print('$url/updateSinImagenes');
     print("_______________________________________________");

     Response response = await put(
        '$url/updateSinImagenes',
        user.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSesion.session_token ?? ''
        }
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

   
    if(response.body==null){
     
     
     Get.snackbar("Error", "No se pudo actualizar la información");
      //retorno vacio
      return ResponseApi();
    }
     if(response.statusCode==401){
       Get.snackbar("Error", "No esta autorizado para realizar este petición");
      //retorno vacio
      print("mario no autorizado");
      return ResponseApi();
    }
    else{
         //creamos un objeto
         ResponseApi responseApi = ResponseApi.fromJson(response.body);
         return responseApi;

    }
  }


  //METODO PARA ACTUALIZAR EL PERFIL CON IMAGENES
  
  Future<Stream> updateWithImage(User user, File image) async {
    final uri = Uri.parse(url+'/updateWithImage');
    final request = http.MultipartRequest('PUT', uri);

    request.headers['Authorization'] = userSesion.session_token ?? '';
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    
    print("****************************************************");
    print(json.encode(user));
    print("****************************************************");

    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }
}