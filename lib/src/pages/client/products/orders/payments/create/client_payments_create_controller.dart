// class ClientPaymentsCreateController extends 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';
import 'package:ios/src/providers/mercado_pago_providers.dart';

class ClientPaymentsController extends GetxController{



      TextEditingController documentsNumberController = TextEditingController();
      var cardNumber=''.obs;
      var expiryDate=''.obs;
      var cardHolderName=''.obs;
      var cvvCode=''.obs;
      var isCvvFocused=false.obs;
      var idDocumento = ''.obs;

      GlobalKey<FormState> formKey =GlobalKey();




      MercadoPagoProviders mercadoPagoProviders = MercadoPagoProviders();
      List<MercadoPagoDocumentType> docu= <MercadoPagoDocumentType> [].obs;


      
      ClientPaymentsController(){
        getDocumentType();
      }


  void onCreditCardModelChange(CreditCardModel creditCardModel){
       
       cardNumber.value = creditCardModel.cardNumber;
       expiryDate.value = creditCardModel.expiryDate;
       cardHolderName.value = creditCardModel.cardHolderName;
       cvvCode.value = creditCardModel.cvvCode;
       isCvvFocused.value = creditCardModel.isCvvFocused;

  }


  //crear el token de mercado pago para hacer la transaccion
  void createCardToken() async {
    String documentNumber = documentsNumberController.text;

    if(isValidForm(documentNumber)){

      //para que no se vaya con espacio el numero de la tarjeta
      cardNumber.value = cardNumber.value.replaceAll(RegExp(' '), '');
      List<String> list = expiryDate.split('/');
      
      //obtengo el mes
      int moth = int.parse(list[0]);
      //obtengo el año
      String year = '20${list[1]}';

       MercadoPagoCardToken mercadoPagoCardToken = await mercadoPagoProviders.createCardToken(
         cardNumber:  cardNumber.value,
         expirationYear: year,
         expirationMonth: moth,
         cardHolderName: cardHolderName.value,
         cvv: cvvCode.value,
         documentId: idDocumento.value,
         documentNumber: documentNumber
       );
       
       if(mercadoPagoCardToken.status=='active'){

               print('MERCADO PAGO: ${mercadoPagoCardToken.toJson()}');

            Get.toNamed('/client/orders/payments/numcuota',arguments: {
                              'card_token': mercadoPagoCardToken.toJson(),
                              'identification_card_type':  idDocumento.value,
                              'identification_number':documentNumber
                            });

       }

                



    }
  }


  bool isValidForm(String documentNumber){
     
     if(cardNumber.value.isEmpty){
      snackbarShow("Formulario no valido", "Ingrese el numero de la tarjeta");
      return false;
     }
     if(expiryDate.value.isEmpty){
      snackbarShow("Formulario no valido", "Ingrese el numero de la tarjeta");
      return false;
     }
      if(cardHolderName.value.isEmpty){
        snackbarShow("Formulario no valido", "Ingrese elnombre del titular");
        return false;
     }
      if(cvvCode.value.isEmpty){
      snackbarShow("Formulario no valido", "Ingrese el codigo de seguridad");
      return false;
     }
      if(idDocumento.value.isEmpty){
         snackbarShow("Formulario no valido", "Slecciona el tipo de documento");
         return false;
     }
     if(documentNumber.isEmpty){
        snackbarShow("Formulario no valido", "Ingrese su numero de documento");
        return false;
     }
     
     return true;
  }

   void snackbarShow(String title,String subtitle){
       Get.snackbar(
          title,
          subtitle,
          icon: Icon(Icons.warning, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.bounceInOut,
        ); 
   }



  
     void getDocumentType() async {
  
         var resul = await mercadoPagoProviders.getAllTypeDocuments();
         docu.clear();
         docu.addAll(resul);

     }


}