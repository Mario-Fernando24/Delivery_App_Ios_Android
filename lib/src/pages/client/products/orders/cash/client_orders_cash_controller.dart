
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/mercado_pago_providers.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientOrdersCashController extends GetxController{


  User userSesion = User.fromJson(GetStorage().read('user') ?? {});
  MercadoPagoProviders mercadoPagoProviders = MercadoPagoProviders();

    void toGoPayments(){
      //
        Get.offAllNamed( ROUTES.payments_create);
    }

    void toGoFinishOrdersCash(BuildContext context){
       createPaymentCash(context);
    }


    void createPaymentCash(BuildContext context) async {

     ProgressDialog progressDialog = ProgressDialog(context: context);

     progressDialog.show(max: 100, msg: "Creando la orden...");

      if(GetStorage().read('direccion')!=null){
      Address a = Address.fromJson(GetStorage().read('direccion'));
      List<Product> products = [];
      if (GetStorage().read(ROUTES.car_shop) is List<Product>) {

        products = GetStorage().read(ROUTES.car_shop);
      }
      else {
        products = Product.fromJsonList(GetStorage().read(ROUTES.car_shop));
      }
  
      Order orden = Order(
        idClient: userSesion.id.toString(),
        idDireccion: a.id.toString(),
        produc: products
      );

          Response response = await mercadoPagoProviders.createPaymentCash(orden: orden);

           if (response.statusCode == 201) {
            progressDialog.close();
              ResponseApi responseApi = ResponseApi.fromJson(response.body);
              Fluttertoast.showToast(msg:responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
              GetStorage().remove(ROUTES.car_shop);
              GetStorage().remove(ROUTES.addresStore);
              goToHome();
              
          }else{
            Fluttertoast.showToast(msg: 'Hubo un error al crear la Orden', toastLength: Toast.LENGTH_LONG);
             progressDialog.close();
          }
    }
 }

    void  goToHome() async{
        Get.offNamedUntil('/client/home', (route) => false);
    }

}