import 'package:get/get.dart';
import 'package:ios/src/environment/environment.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';

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

    if(response.statusCode != 201){
       Get.snackbar('Error', 'No se pudo validar la tarjeta');
       return MercadoPagoCardToken();
       
    }

    //si no agrego al fromJson la respuesta y la retorno
    MercadoPagoCardToken responseApi = MercadoPagoCardToken.fromJson(response.body);
    return responseApi;
  }

}