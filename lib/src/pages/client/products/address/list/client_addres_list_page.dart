import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/pages/client/products/address/list/client_addres_list_controller.dart';
import 'package:ios/src/widget/no_data_widget.dart';

//LISTA DE DIRECCIONES DE LOS CLIENTES DONDE SE LE VAN A ENVIAR LOS PEDIDOS
class ClientAddresListPage extends StatelessWidget {
 
    ClientAddresListController _clientAddresListController = Get.put(ClientAddresListController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Mis Direcciones',style: TextStyle(color: Colors.black),),
        actions: [iconAddresClient()],
      ),
      body: GetBuilder<ClientAddresListController>(
        builder: (value) => Stack(
          children: [
              _textSelectAddress(),
              _listAddress(context)
        ]
        ),
      ),
    );
  }

  Widget _textSelectAddress(){

    return Container(
      margin: EdgeInsets.only(top: 30, left: 30.0),
      child: Text( 'Elije donde recibir tu pedido', 
      style: TextStyle(
        color: Colors.black,
        fontSize: 19, 
        fontWeight: FontWeight.bold),
      ),
    );
  }


  Widget _listAddress(BuildContext context){
      return  Container(
        margin: EdgeInsets.only(top: 50.0),
        child: FutureBuilder(
        future: _clientAddresListController.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){
          print('=======mario fernando=================');
          print(snapshot.data);
          print('=====mario fernando======');
          //si tiene informacion
          if(snapshot.hasData){
            //si la data no este vacia
            if(snapshot.data!.isNotEmpty){
               return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (_,index){
                  return _radioSelectorAddress(snapshot.data![index], index);
                });
            }else{
               return Center(
             child: NoDataWidget(text: 'No hay direcciones',)
            );
            }

          }else{
            return Center(
             child: NoDataWidget(text: 'No hay direcciones',)
            );
          }

        },
        ),
      );
  }

 //envia el modelo y la posicion para saber que posicion estamos seleccionando
  Widget _radioSelectorAddress(Address address, int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19),
      child: Column(
        children: [
          Row(
            children: [
                Radio(
                value: index,
                groupValue: _clientAddresListController.radioValue.value, 
                onChanged: _clientAddresListController.selRadioChamge
                ),
                Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.direccion ?? '',style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold),),
                      Text(address.nombreBarrio ?? '',style: TextStyle(
                      fontSize: 12),)
                  ],
                )
            ],
          ),

          Divider(color: Colors.grey[400],)
        ],
      ),
    );
  }

  Widget iconAddresClient(){
     return IconButton(
      onPressed: ()=>_clientAddresListController.goToAddresCreate(),
      icon: Icon(
        Icons.add,color: Colors.black)
      );
  }
}