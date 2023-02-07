import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';
import 'package:ios/src/models/mercado_pago_payment_method.dart';
import 'package:ios/src/models/mercado_pago_payment_method_installments.dart';
import 'package:ios/src/models/response_api.dart';

class MercadoPagoProviders extends GetConnect{

     String url = Environment.API_MERCADO_PAGO;
     String urlRest = Environment.API_URL;
     User userSesion = User.fromJson(GetStorage().read('user') ?? {});

     Future<List<MercadoPagoDocumentType>> getAllTypeDocuments() async {  
     
     Response response = await get(
        '$url/identification_types',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Environment.ACCESS_TOKEN}' ?? ''
        }
    ); 
    
    if(response.statusCode==401){
        Get.snackbar("Error", "No tiene permisos");
        return [];
    }
    List<MercadoPagoDocumentType> documents =MercadoPagoDocumentType.fromJsonList(response.body);
    return documents;
  }



   //obtener el numero de cuota de la tarjeta ingresada recibimos la cantidad de cuotas que queremos y bin los primeros 6 digitos de la tqrjeta
    Future<MercadoPagoPaymentMethodInstallments> getNumCuota(String bin, double amount) async {  
     
        Response response = await get(
            '$url/payment_methods/installments',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${Environment.ACCESS_TOKEN}' ?? ''
            },
            query: {
              'bin': bin,
              'amount': '${amount}'
            }
        ); 

      print(')))))))))))))))))))))))))');
      print(response.body);
      print(response.statusCode);
      
      print(')))))))))))))))))))))))))');
    if(response.statusCode==401){
        Get.snackbar("Error", "No tiene permisos");
        return MercadoPagoPaymentMethodInstallments();
    }

    if(response.body==[]){
        Get.snackbar("Error", "No se pudo obtener las cuotas de la tarjetas");
        return MercadoPagoPaymentMethodInstallments();
    }


     if(response.statusCode!=200){
        Get.snackbar("Error", "No se pudo obtener las cuotas de la tarjetas");
        return MercadoPagoPaymentMethodInstallments();
    }
    MercadoPagoPaymentMethodInstallments data =MercadoPagoPaymentMethodInstallments.fromJson(response.body[0]);
   print('MARIO FERNANDO MU====>: ${data.toJson()}');
    
    return data;
  }




  //creando el pago
  Future<Response> createPayment({
    
    @required String? token,
    @required String? paymentMethodId,
    @required String? paymentTypeId,
    @required String? emailCustomer,
    @required String? issuerId,
    @required String? identificationType,
    @required String? identificationNumber,
    @required double? transactionAmount,
    @required int? installments,
    @required Order? orden}) async  {


       Response response = await post(
        '${urlRest}api/payments/create',{
           
            'token': token,
            'issuer_id': issuerId,
            'payment_method_id': paymentMethodId,
            'transaction_amount': transactionAmount,
            'installments': installments,
            'description': "",
            'payer': {
              'email': emailCustomer ,
              'identification': {
                'type': identificationType,
                'number': identificationNumber,
              },
            },
            'order': orden!.toJson()
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSesion.session_token ?? ''
        }
    ); 
          
            print('RESPUESTA DE LA DATA:: ${response.body}');
            print('ESTATUS DE LA DATA:: ${response.statusCode}');
        // ResponseApi responseApi = ResponseApi.fromJson(response.body);

       return response;


  
    }



   //creamos el pago de pago
   Future<MercadoPagoCardToken> createCardToken({
      String? cvv,
      String? expirationYear,
      int? expirationMonth,
      String? cardNumber,
      String? cardHolderName,
      String? documentNumber,
      String? documentId  

   }) async {
     
     Response response = await post(
        '$url/card_tokens?public_key=${Environment.PUBLIC_KEY}}',{
          'security_code': cvv,
          'expiration_year': expirationYear,
          'expiration_month': expirationMonth,
          'card_number': cardNumber,
          'cardholder': {
               'name': cardHolderName,
               'identification': {
                   'number': documentNumber,
                   'type': documentId
               }

          }

        },
        headers: {
          'Content-Type': 'application/json',

        }
    ); 
   print('========================>${response.statusCode}');
    if(response.statusCode != 201){
       Get.snackbar('Error', 'No se pudo validar la tarjeta');
       return MercadoPagoCardToken();
       
    }

    //si no agrego al fromJson la respuesta y la retorno
    MercadoPagoCardToken responseApi = MercadoPagoCardToken.fromJson(response.body);
    return responseApi;
  }

}