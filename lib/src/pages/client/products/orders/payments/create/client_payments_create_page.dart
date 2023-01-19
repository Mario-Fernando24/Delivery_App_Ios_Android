import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/mercado_pago_document_type.dart';
import 'package:ios/src/pages/client/products/orders/payments/create/client_payments_create_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  ClientPaymentsCreatePage({Key? key}) : super(key: key);

  

  @override
  State<ClientPaymentsCreatePage> createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {
     ClientPaymentsController _clientPaymentsController = Get.put(ClientPaymentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Scaffold(
      bottomNavigationBar:  _buttonNext(context),
      body: ListView(children: [
          //TARJETA
              CreditCardWidget(
                   //numero de la tarjeta
                  cardNumber: _clientPaymentsController.cardNumber.value,
                  //fecha de expiracion
                  expiryDate:_clientPaymentsController.expiryDate.value,
                  //propietario
                  cardHolderName: _clientPaymentsController.cardHolderName.value,
                  //codigo de seguridad
                  cvvCode: _clientPaymentsController.cvvCode.value,
                  //parte de atras de la tarjeta
                  showBackView: _clientPaymentsController.isCvvFocused.value,
                  cardBgColor: miTemaPrincipal,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  height: 175,
                  labelCardHolder: 'NOMBRE Y APELLIDO',
                  textStyle: TextStyle(color: Colors.black),
                  width: MediaQuery.of(context).size.width,
                  //argumento
                  animationDuration: Duration(milliseconds: 1000), onCreditCardWidgetChange: (CreditCardBrand ) {  },
                  //nos permite hacer un gradiente
                  glassmorphismConfig: Glassmorphism(
                          blurX: 10.0,
                          blurY: 10.0,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colors.grey.withAlpha(50),
                              Colors.black.withAlpha(50),
                            ],
                            stops: const <double>[
                              0.3,
                              0,
                            ],
                          ),
                        ),
  
            ),



                Container( 
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: CreditCardForm(
                         formKey: _clientPaymentsController.formKey, // Required 
                          
                          onCreditCardModelChange: _clientPaymentsController.onCreditCardModelChange, // Required
                          themeColor: Colors.red,
                          obscureCvv: true, 
                          obscureNumber: true,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardNumberValidator: (String? cardNumber){},
                          expiryDateValidator: (String? expiryDate){},
                          cvvValidator: (String? cvv){},
                          cardHolderValidator: (String? cardHolderName){},
                          onFormComplete: () {
                          // callback to execute at the end of filling card data
                          },
                          cardNumberDecoration: const InputDecoration(
                         //   prefixIcon: Icon(Icons.credit_card), // parte izquierda el icono
                            suffixIcon:  Icon(Icons.credit_card),
                            labelText: 'Numero de la tarjeta',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: const InputDecoration(
                            suffixIcon:  Icon(Icons.date_range),
                            labelText: 'Expiración',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: const InputDecoration(
                            suffixIcon:  Icon(Icons.lock),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            suffixIcon:  Icon(Icons.person),
                            labelText: 'Titular de la tarjeta',
                          ),
                           cardHolderName: '',
                           cardNumber: '',
                           cvvCode: '',
                           expiryDate: '',
  
                        ),
                ),

                _dropDownTypeDocument(_clientPaymentsController.docu),
                _documentsNumber()
                
               
        ],
      )
    ));
  }

  Widget _buttonNext(BuildContext context){
  return Container(
    width: double.infinity,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: ElevatedButton(
      onPressed: ()=>(){},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Continuar",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}




      Widget _dropDownTypeDocument(List<MercadoPagoDocumentType> documents) {
      
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            margin: EdgeInsets.only(top: 15),
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
                'Seleccionar tipo de documento',
                style: TextStyle(
                  fontSize: 15
                ),
              ),
              items: _dropdownMenuItem(documents),
              value: _clientPaymentsController.idDocumento.value == '' ? null : _clientPaymentsController.idDocumento.value,
              onChanged: (option) {
                print('Opcion seleccionada ${option}');
                _clientPaymentsController.idDocumento.value = option.toString();
              },
            ),
          );
        }

      List<DropdownMenuItem<String>> _dropdownMenuItem(List<MercadoPagoDocumentType> documents){
        List<DropdownMenuItem<String>> list =[];
        documents.forEach((docum) {
              list.add(DropdownMenuItem(
                child: Text(docum.name ?? ''),
                value: docum.id,
                ));
        });

        return list;
      }


      Widget _documentsNumber(){
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 37, vertical:10),
            child: TextField(
              controller: _clientPaymentsController.documentsNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Numero de documento',
                prefixIcon: Icon(Icons.description)
              ),
            ),
          );
}



}