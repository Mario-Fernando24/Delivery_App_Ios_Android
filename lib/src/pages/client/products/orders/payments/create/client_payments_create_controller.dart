// class ClientPaymentsCreateController extends 

import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';

class ClientPaymentsController extends GetxController{

      var cardNumber=''.obs;
      var expiryDate=''.obs;
      var cardHolderName=''.obs;
      var cvvCode=''.obs;
      var isCvvFocused=false.obs;

      GlobalKey<FormState> formKey =GlobalKey();



  void onCreditCardModelChange(CreditCardModel creditCardModel){
       
       cardNumber.value = creditCardModel.cardNumber;
       expiryDate.value = creditCardModel.expiryDate;
       cardHolderName.value = creditCardModel.cardHolderName;
       cardNumber.value = creditCardModel.cardNumber;
       cvvCode.value = creditCardModel.cvvCode;
       isCvvFocused.value = creditCardModel.isCvvFocused;

  }
}