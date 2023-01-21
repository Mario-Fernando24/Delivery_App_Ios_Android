import 'package:get/get.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';
import 'package:ios/src/models/mercado_pago_payment_method.dart';
import 'package:ios/src/models/mercado_pago_payment_method_installments.dart';

class MercadoPagoProviders extends GetConnect{

     String url = Environment.API_MERCADO_PAGO;

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

     
    if(response.statusCode==401){
        Get.snackbar("Error", "No tiene permisos");
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