import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_installment.dart';
import 'package:ios/src/models/mercado_pago_payment.dart';
import 'package:ios/src/models/mercado_pago_payment_method_installments.dart';
import 'package:ios/src/models/response_api.dart';
import 'package:ios/src/providers/mercado_pago_providers.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientPaymentsNumCuotasController extends GetxController{


  MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(Get.arguments['card_token']);

  String identificationCardType=Get.arguments['identification_card_type'];
  
  String identificatioNumber=Get.arguments['identification_number'];

     MercadoPagoProviders mercadoPagoProviders = MercadoPagoProviders();
     var total=0.0.obs;
     var selectProducts =<Product>[].obs;
     var numCuotaaaa = ''.obs;
     User userSesion = User.fromJson(GetStorage().read('user') ?? {});

     //lista donde guardo la lista de las cuota de cada tarjeta
     List<MercadoPagoInstallment> numCuotaList = <MercadoPagoInstallment>[].obs;
     MercadoPagoPaymentMethodInstallments? _mercadoPagoPaymentMethodInstallments;

     
    //obtengo en el constructor los producto guardados en el GetStorage y lo almaceno en una lista de producto
     ClientPaymentsNumCuotasController(){
     
       if(GetStorage().read(ROUTES.car_shop)!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read(ROUTES.car_shop) is List<Product>){
            //le asigno el array que esta en el Gestorage y se lo asigno a la variable result
            var result =GetStorage().read(ROUTES.car_shop); 
            print("*********************************************************************");
            // print("mario fernando"+result);
            print("*********************************************************************");
            // vacio la lista de producto
            selectProducts.clear();
            // agrego los producto del result a la list de produto donde estan todos los productos que escogio el usuario
            selectProducts.addAll(result);
          
          }else{
            var result =Product.fromJsonList(GetStorage().read(ROUTES.car_shop));
            selectProducts.clear();
            selectProducts.addAll(result);
       }
       getTotal();
       getNumCuota();
      
      }
    }


  void createPayment(BuildContext context) async {

    //validamos que el usuario haya seleccionado el numero de cuotas
      if(numCuotaaaa.value.isEmpty){
        Get.snackbar('Formulario no valido', 
         snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
        ' Selecciona el numero de cuotas');
        return ;
      }


     ProgressDialog progressDialog = ProgressDialog(context: context);

     progressDialog.show(max: 100, msg: "Creando la orden...");

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
    
    Response response = await mercadoPagoProviders.createPayment(
      token: cardToken.id,
      paymentMethodId: _mercadoPagoPaymentMethodInstallments!.paymentMethodId,
      paymentTypeId: _mercadoPagoPaymentMethodInstallments!.paymentTypeId,
      issuerId: _mercadoPagoPaymentMethodInstallments!.issuer!.id,
      transactionAmount: total.value,
      //numero de cuota
      installments: int.parse(numCuotaaaa.value),
      emailCustomer: userSesion.email,
      orden: order,
      identificationType:identificationCardType ,
      identificationNumber: '${identificatioNumber}'
    );
    progressDialog.close();

  
       if (response.statusCode == 201) {
      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      MercadoPagoPayment mercadoPagoPayment = MercadoPagoPayment.fromJson(responseApi.data);

        print("#############################################################################################");
    print(mercadoPagoPayment.toJson());
    print("#############################################################################################");


      GetStorage().remove(ROUTES.car_shop);
      Get.offNamedUntil('/client/orders/payments/status', (route) => false, arguments: {
        'mercado_pago_payment':  mercadoPagoPayment.toJson()
      });
    }
    else if (response.statusCode == 501){
      print('RESPONSE BODY 501: ${response.body}');

      if (response.body['error']['status'] == 400) {
        print('BODY ERROR: ${response.body['error'].toString()}');
        print('BODY mario: ${response.body['error']}');
        badRequestProcess(response.body['error']);
      }
      else {
        badTokenProcess(response.body['error']['status'], _mercadoPagoPaymentMethodInstallments!);
      }
    }
    

  // if (response.statusCode == 201) {
   
  //     // ResponseApi responseApi = ResponseApi.fromJson(response.body);
  //     // MercadoPagoPayment mercadoPagoPayment = MercadoPagoPayment.fromJson(responseApi.data);
  //     // GetStorage().remove('shopping_bag');
  //     // Get.offNamedUntil('/client/orders/payments/status', (route) => false, arguments: {
  //     //   'mercado_pago_payment':  mercadoPagoPayment.toJson()
  //     // });
  //   }

    // if(response.statusCode==201){
      
    //    print('PASO 11111111111111');

    //   ResponseApi  responseApi = ResponseApi.fromJson(response.body);
    //    print('PASO 2222222222222'+responseApi.data.toString());
    //     MercadoPagoPayment mercadoPagoPayment = MercadoPagoPayment.fromJson(responseApi.data);

    //       GetStorage().remove(ROUTES.car_shop);

    //       print('ESTADO STATUS MARIO');
    //       print(response.statusCode);
    //       Get.offNamedUntil('/client/orders/payments/status',(route)=>false, arguments: {
    //         'mercado_pago_payment': mercadoPagoPayment.toJson()
    //       });

    // }
   
  }else{
    // progressDialog.close();
    Fluttertoast.showToast(msg: 'Por favor escoger una opción de dirección', toastLength: Toast.LENGTH_LONG);
   }
  }

    void getNumCuota() async {

      if(cardToken.firstSixDigits!=null){
             
       var result = await mercadoPagoProviders.getNumCuota(cardToken.firstSixDigits!, total.value);
       //le asignamos las propierdades a este modelo
        _mercadoPagoPaymentMethodInstallments = result;
       print('RESULTADO:  ${result.payerCosts!}');
       if(result.payerCosts!=null){
           numCuotaList.clear();
           numCuotaList.addAll(result.payerCosts!);
       }
       


        //numCuotaList
      }
                                           
 
    }

      void getTotal(){
            total.value=0.0;
            //recorremos la lista con un for
              selectProducts.forEach((product) {
              total.value+=total.value+(product.quantity! * product.price!);
            });
          }



  void badRequestProcess(dynamic data){
    Map<String, String> paymentErrorCodeMap = {
      '3034' : 'Informacion de la tarjeta invalida',
      '3033' : 'La longitud de digitos de tu tarjeta es erroneo',
      '3032' : 'Por favor verifica el CVV de tu tarjeta',
      '205' : 'Ingresa el número de tu tarjeta',
      '208' : 'Digita un mes de expiración',
      '209' : 'Digita un año de expiración',
      '212' : 'Ingresa tu documento',
      '213' : 'Ingresa tu documento',
      '214' : 'Ingresa tu documento',
      '220' : 'Ingresa tu banco emisor',
      '221' : 'Ingresa el nombre y apellido',
      '224' : 'Ingresa el código de seguridad',
      'E301' : 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302' : 'Revisa el código de seguridad',
      '316' : 'Ingresa un nombre válido',
      '322' : 'Revisa tu documento',
      '323' : 'Revisa tu documento',
      '324' : 'Revisa tu documento',
      '325' : 'Revisa la fecha',
      '326' : 'Revisa la fecha'
    };
    String? errorMessage;
    print('CODIGO ERROR ${data['cause'][0]['code']}');

    if(paymentErrorCodeMap.containsKey('${data['cause'][0]['code']}')){
      print('ENTRO IF');
      errorMessage = paymentErrorCodeMap['${data['cause'][0]['code']}'];
    }else{
      errorMessage = 'No pudimos procesar tu pago';
    }
    Get.snackbar('Error con tu informacion', errorMessage ?? '');
    // Navigator.pop(context);
  }

 void badTokenProcess(String status, MercadoPagoPaymentMethodInstallments installments){
    Map<String, String> badTokenErrorCodeMap = {
      '106' : 'No puedes realizar pagos a usuarios de otros paises.',
      '109' : '${installments.paymentMethodId} no procesa pagos en ${this.numCuotaaaa.value} cuotas',
      '126' : 'No pudimos procesar tu pago.',
      '129' : '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145' : 'No pudimos procesar tu pago',
      '150' : 'No puedes realizar pagos',
      '151' : 'No puedes realizar pagos',
      '160' : 'No pudimos procesar tu pago',
      '204' : '${installments.paymentMethodId} no está disponible en este momento.',
      '801' : 'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
    };
    String? errorMessage;
    if(badTokenErrorCodeMap.containsKey(status.toString())){
      errorMessage =  badTokenErrorCodeMap[status];
    }else{
      errorMessage =  'No pudimos procesar tu pago';
    }
    Get.snackbar('Error en la transaccion', errorMessage ?? '');
    // Navigator.pop(context);
  }


}