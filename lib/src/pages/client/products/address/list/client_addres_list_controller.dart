import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/address_providers.dart';
import 'package:ios/src/providers/orders_providers.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientAddresListController extends GetxController{

     List<Address> address =<Address>[].obs;
     AddressProviders addressProviders = AddressProviders();
     OrdersProviders ordersProviders = OrdersProviders();
     User userSesion = User.fromJson(GetStorage().read('user') ?? {});
     var radioValue=0.obs;

     BuildContext? context = Get.key.currentContext;


    ClientAddresListController(){
      print('LA DIRECCION DE SESSION  ${GetStorage().read('direccion')}');
      
    }


    void goToAddresCreate(){
      Get.toNamed('/client/addres/create');
    }


   Future<List<Address>> getAddress() async{
      
        address = await addressProviders.getByfindId();

        // valido si la la direccion en localstora no esta null
       if(GetStorage().read('direccion')!=null){

         Address a = Address.fromJson(GetStorage().read('direccion'));
        // //preguntamos si la direccion de session es igual a la que listamos de nuestra base de dato
        int index=address.indexWhere((dire) => dire.id==a.id);
        //   //si esto es true coincide
         if(index!=-1){
           radioValue.value=index;
         }}
       
        return address;
  }

  void selRadioChamge(int? value){
    radioValue.value=value!;
        print("Mario fernando posiction${value}");

    GetStorage().write('direccion',address[value].toJson());
    update();
  }

  void createOrders() async {
         Get.toNamed(ROUTES.payments_create);

    // ProgressDialog progressDialog = ProgressDialog(context: context);

    // progressDialog.show(max: 100, msg: "Creando la orden...");
/*
     if(GetStorage().read('direccion')!=null){

     Address a = Address.fromJson(GetStorage().read('direccion'));
     //obtengo los productos del localstora de la bolsa de compra

    List<Product> products = [];
    if (GetStorage().read(ROUTES.car_shop) is List<Product>) {

      products = GetStorage().read(ROUTES.car_shop);
    }
    else {

      products = Product.fromJsonList(GetStorage().read(ROUTES.car_shop));
    }
  
    Order order = Order(
      idClient: userSesion.id.toString(),
      idDireccion: a.id.toString(),
      produc: products
    );
    
    ResponseApi responseApi = await ordersProviders.createOrders(order);

    Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

    if(responseApi.success==true){
    //  progressDialog.close();
    //  GetStorage().remove(ROUTES.car_shop);

      Get.toNamed(ROUTES.payments_create);
    }
 
  }else{
    // progressDialog.close();
    Fluttertoast.showToast(msg: 'Por favor escoger una opción de dirección', toastLength: Toast.LENGTH_LONG);
  }
  **///
 
 }

}
