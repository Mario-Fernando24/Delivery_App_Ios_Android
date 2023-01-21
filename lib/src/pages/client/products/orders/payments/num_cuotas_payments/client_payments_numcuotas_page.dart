import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/mercado_pago_installment.dart';
import 'package:ios/src/pages/client/products/orders/payments/num_cuotas_payments/client_payments_numcuotas_controller.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';

class ClientPaymentsNumCuotasPage extends StatefulWidget {
  const ClientPaymentsNumCuotasPage({Key? key}) : super(key: key);

  @override
  State<ClientPaymentsNumCuotasPage> createState() => _ClientPaymentsNumCuotasPageState();
}

class _ClientPaymentsNumCuotasPageState extends State<ClientPaymentsNumCuotasPage> {
  ClientPaymentsNumCuotasController clientPaymentsNumCuotasController = Get.put(ClientPaymentsNumCuotasController());

  @override
  Widget build(BuildContext context) {
// Get.put(ClientPaymentsController());
    return Obx(()=> Scaffold(
       bottomNavigationBar: Container(
        height: 100,
        color: Color.fromRGBO(245, 245, 245, 1),
        child: totalToPay(context),
      ),
        appBar: AppBar(
        iconTheme: IconThemeData( 
          color: Colors.black
        ),
        title: Text("Cuotas", 
        style: TextStyle(
          color: Colors.black
        ),),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           _textDescription(),
           _dropDownNumCuota(clientPaymentsNumCuotasController.numCuotaList)
        ],
      ),
     ),
    );
  }

    Widget _textDescription(){
      return Container(
        margin: EdgeInsets.all(30),
        child: Text('En cuantas cuotas ?',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
      );
    }

  // MercadoPagoInstallment modelo que nos trae el numero de cuota de la tarjeta
      Widget _dropDownNumCuota(List<MercadoPagoInstallment> numCuota) {
      
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: DropdownButton(
              underline: Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.amber,
                ),
              ),
              elevation: 3,
              isExpanded: true,
              hint: Text(
                'Selecciona numero de cuota',
                style: TextStyle(
                  fontSize: 15
                ),
              ),
              items: _dropdownMenuItem(numCuota),
              value: clientPaymentsNumCuotasController.numCuotaaaa.value == '' ? null : clientPaymentsNumCuotasController.numCuotaaaa.value,
              onChanged: (option) {
                print('Opcion seleccionada ${option}');
                clientPaymentsNumCuotasController.numCuotaaaa.value = option.toString();
              },
            ),
          );
        }

      List<DropdownMenuItem<String>> _dropdownMenuItem(List<MercadoPagoInstallment> numCuota){
        List<DropdownMenuItem<String>> list =[];
        numCuota.forEach((numCuota) {
              list.add(DropdownMenuItem(
                //'cuota ${numCuota.installments} 
                child: Text('  ${numCuota.installments}' ),

                // child: Text('  ${numCuota.recommendedMessage}' ),
                value: '${numCuota.installments}',
                ));
        });

        return list;
      }

     Widget totalToPay(BuildContext context){
          
          return  Column(
            children: [
              Divider(height: 1,color: Colors.grey),

            Container(
              margin: EdgeInsets.only(left:5, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('TOTAL: ${numberFormat(clientPaymentsNumCuotasController.total.toString())}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),),

                Container(

                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                   onPressed: ()=>{},
                   style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10)
                   ),
                   child: Text("CONFIRMAR PAGO: ",
                   style: TextStyle(
                    color: Colors.black
                   ),)),
                  )
                 ],
                ),
            )
            ],
          );
     }
}