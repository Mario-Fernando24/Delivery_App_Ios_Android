// class ClientPaymentsCreateController extends 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';
import 'package:ios/src/providers/mercado_pago_providers.dart';

class ClientPaymentsController extends GetxController{



      TextEditingController documentsNumberController = TextEditingController();
      var cardNumber=''.obs;
      var expiryDate=''.obs;
      var cardHolderName=''.obs;
      var cvvCode=''.obs;
      var isCvvFocused=false.obs;

      GlobalKey<FormState> formKey =GlobalKey();


      var idDocumento = ''.obs;


      MercadoPagoProviders mercadoPagoProviders = MercadoPagoProviders();
      List<MercadoPagoDocumentType> docu= <MercadoPagoDocumentType> [].obs;


      
      ClientPaymentsController(){
        getDocumentType();
      }


  void onCreditCardModelChange(CreditCardModel creditCardModel){
       
       cardNumber.value = creditCardModel.cardNumber;
       expiryDate.value = creditCardModel.expiryDate;
       cardHolderName.value = creditCardModel.cardHolderName;
       cardNumber.value = creditCardModel.cardNumber;
       cvvCode.value = creditCardModel.cvvCode;
       isCvvFocused.value = creditCardModel.isCvvFocused;

  }


  
     void getDocumentType() async {
  
         var resul = await mercadoPagoProviders.getAllTypeDocuments();
         docu.clear();
         docu.addAll(resul);

     }


}