import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/orders/payments/status/client_payments_status_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class ClientPaymentStatusPage extends StatefulWidget {
  const ClientPaymentStatusPage({Key? key}) : super(key: key);

  @override
  State<ClientPaymentStatusPage> createState() => _ClientPaymentStatusPageState();
}

class _ClientPaymentStatusPageState extends State<ClientPaymentStatusPage> {

       ClientPaymentStatusController clientPaymentStatusController = Get.put(ClientPaymentStatusController());


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _texTransaccion(context)
      ],
      ),
    );
  }

Widget _backgruoundCover(BuildContext context){
   return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height*0.4,
    color: miTemaPrincipal,
   );
}

Widget _texTransaccion(BuildContext context){
  return  SafeArea(
    child: Container(
      margin: EdgeInsets.only(top:16 ),
      alignment: Alignment.topCenter,
        child: Column(
          children: [
          clientPaymentStatusController.mercadoPagoPayment.status == 'approved'
            ? Icon(Icons.check_circle, size: 100, color: Colors.green)
            : Icon(Icons.cancel, size: 100, color: Colors.red),
          Text("TRANSACCIÓN TERMINADA ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
          ])
    )
  );
}

Widget _boxForm(BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.34, left: 30, right: 30),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black54,
          blurRadius: 15,
          offset: Offset(0.0,75)
        )
      ]
    ),
    height: MediaQuery.of(context).size.height*0.60,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textTransactionDetail(),
          _texTransactionStatus(),
          _buttonFinalizar(context)
        ],
      ),
    ),
  );
}



 Widget _textTransactionDetail() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30, left: 25, right: 25),
      child: Text(
        clientPaymentStatusController.mercadoPagoPayment.status == 'approved'
        ? 'Tu orden fue procesada exitosamente usando (${clientPaymentStatusController.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${clientPaymentStatusController.mercadoPagoPayment.card?.lastFourDigits})'
        : 'Tu pago fue rechazado',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

Widget _texTransactionStatus(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text(clientPaymentStatusController.mercadoPagoPayment.status=='approved' ?
    'Mira el estado de tu compra en la seccion de MIS PEDIDOS'
    : clientPaymentStatusController.errorMessage.value,
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _buttonFinalizar(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
    child: ElevatedButton(
      onPressed: ()=> clientPaymentStatusController.finishShoping(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("FINALIZAR COMPRA",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
 }
}