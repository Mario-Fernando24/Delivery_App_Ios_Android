import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/orders/cash/client_orders_cash_controller.dart';

class ClientOrderCash extends StatefulWidget {
  const ClientOrderCash({Key? key}) : super(key: key);

  @override
  State<ClientOrderCash> createState() => _ClientOrderCashState();
}

class _ClientOrderCashState extends State<ClientOrderCash> {
      ClientOrdersCashController _clientOrdersCashController = Get.put(ClientOrdersCashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 6, 66, 12),
      body: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          cardPay(context),
          cardCredit(context)
        ],
      )
    );
  }



Widget cardPay(BuildContext context){

    return Container(
        padding: EdgeInsets.only(top: 50.0),
          width: MediaQuery.of(context).size.width*0.45,
          height: MediaQuery.of(context).size.height*0.19,
              child: Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(20.0),
                    ),
                    side: BorderSide(color: Color.fromARGB(255, 8, 8, 8))),
                  color:  Color.fromARGB(189, 249, 253, 250),
                  child: InkWell(
                    onTap: ()=> _clientOrdersCashController.toGoFinishOrdersCash(context),
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("EFECTIVO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                                fontFamily: "medium",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
      );
}


  Widget cardCredit(BuildContext context){

              return Container(
                 padding: EdgeInsets.only(top: 50.0),
                    width: MediaQuery.of(context).size.width*0.45,
                    height: MediaQuery.of(context).size.height*0.19,
                        child: Card(
                            elevation: 2,
                            margin: EdgeInsets.zero,
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(0.0),
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(20.0),
                              ),
                              side: BorderSide(color: Color.fromARGB(255, 8, 8, 8))),
                            color:  Color.fromARGB(189, 249, 253, 250),
                              child: InkWell(
                              onTap: ()=> _clientOrdersCashController.toGoPayments(),
                              child: Container(
                                height: 60,
                                padding: EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0, bottom: 8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("TARJETA",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "medium",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  ),
                );
         }
}