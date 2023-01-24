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
     
       if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
            //le asigno el array que esta en el Gestorage y se lo asigno a la variable result
            var result =GetStorage().read('bolsa_compra'); 
            print("*********************************************************************");
            // print("mario fernando"+result);
            print("*********************************************************************");
            // vacio la lista de producto
            selectProducts.clear();
            // agrego los producto del result a la list de produto donde estan todos los productos que escogio el usuario
            selectProducts.addAll(result);
          
          }else{
            var result =Product.fromJsonList(GetStorage().read('bolsa_compra'));
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
    if (GetStorage().read('bolsa_compra') is List<Product>) {

      products = GetStorage().read('bolsa_compra');
    }
    else {

      products = Product.fromJsonList(GetStorage().read('bolsa_compra'));
    }
  
    Order order = Order(
      idClient: userSesion.id.toString(),
      idDireccion: a.id.toString(),
      produc: products
    );
    
    ResponseApi responseApi = await mercadoPagoProviders.createPayment(
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

    Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

    if(responseApi.success==true){
    //  progressDialog.close();
    //  GetStorage().remove('bolsa_compra');

      // Get.toNamed(ROUTES.payments_create);
    }
 
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
}