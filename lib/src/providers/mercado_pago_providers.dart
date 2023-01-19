import 'package:get/get.dart';
import 'package:ios/src/environment/environment.dart';
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

}