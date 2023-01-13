import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/orders/detail/client_orders_detail_controller.dart';
import 'package:ios/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
import 'package:ios/src/utils/relative_time_util.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class ClientOrdersDetailPage extends StatelessWidget {
  ClientOrdersDetailPage({Key? key}) : super(key: key);

   ClientOdersDetailController _clientOdersDetailController = Get.put(ClientOdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>  Scaffold(
       bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.5,
        color: Color.fromRGBO(245, 245, 245, 1),
        child: SingleChildScrollView(
          child: Column(
            children:[
             _dataDate(),
             _dataDomiciliario(),
             _dataDireccion(),
            //  _domiciliarioAsignado(),
             totalToPay(context)
            ]
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black),
        title: Text('Order # ${_clientOdersDetailController.order.id}',
        style: TextStyle(color: Colors.black)),
      ),
      body:  _clientOdersDetailController.order.produc!.length>0 ?
            Container(
              margin: EdgeInsets.only(bottom: 13.0),
              child: ListView(
                children: _clientOdersDetailController.order.produc!.map((Product product) {
                   return _cardProduct(product);
                }).toList(),
              ),
            ) :
             Center(child: NoDataWidget(text: "No hay ningun producto aun",))
        )
      );
   }


       Widget _cardProduct(Product product){
      
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
            children: [
              _imageProduct(product),
              SizedBox(width: 15),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name ?? '',style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0
                ),),
                SizedBox(height: 3.0),
                Row(
                  children: [
                    Text('Cantidad: ${product.quantity ?? ''}',style: TextStyle(fontSize: 12.0),),
                    Text('\$ ${product.price ?? ''}',style: TextStyle(fontSize: 12.0),),
                  ],
                ),
              ],
             ),
          ],
          ),
      ); 

     }



    Widget _imageProduct(Product product){

       return Container(
              height: 50.0,
              width: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FadeInImage(
                  image: product.image1!=null ?
                  NetworkImage(product.image1 ?? '')
                  : AssetImage('assets/img/no-image.png') as ImageProvider,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  //en caso de que no venga ninguna imagen
                  placeholder: AssetImage('assets/img/no-image.png'), 
                  ),
              ),
            );
     }


     Widget _dataDomiciliario(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Domiciliario y telefono'),
          subtitle: _clientOdersDetailController.order.domiciliario_json!.name!=null ? Text('${_clientOdersDetailController.order.domiciliario_json!.name ?? ''} ${_clientOdersDetailController.order.domiciliario_json!.lastname ?? ''}  -  ${_clientOdersDetailController.order.domiciliario_json!.phone ?? ''} '):Text('No asignado'),
          trailing: Icon(
            Icons.person
          ),
        ),
      );
     }


    //    Widget _domiciliarioAsignado(){
    //   return Container(
    //     margin: EdgeInsets.symmetric(horizontal: 20.0),
    //     child: ListTile(
    //       title: Text('Domiciliario asignado'),
    //       subtitle:Text('${_clientOdersDetailController.order.domiciliario_json!.name ?? ''} ${_clientOdersDetailController.order.domiciliario_json!.lastname ?? ''}  -  ${_clientOdersDetailController.order.domiciliario_json!.phone ?? ''} '),
    //       trailing: Icon(
    //         Icons.delivery_dining
    //       ),
    //     ),
    //   );
    //  }
     
     Widget _dataDireccion(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Direccion de entrega'),
          subtitle:Text('${_clientOdersDetailController.order.direccion_json!.direccion ?? ''} '),
          trailing: Icon(
            Icons.location_on
          ),
        ),
      );
     }

     Widget _dataDate(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Fecha del pedido'),
          subtitle:Text('${ RelativeTimeUtil.getRelativeTime(_clientOdersDetailController.order.timetamp ?? 0)} '),
          trailing: Icon(
            Icons.timer
          ),
        ),
      );
     }



   
     Widget totalToPay(BuildContext context){
          
          return  Column(
              children: [
              Divider(height: 1,color: Colors.grey[400]),
              Container(
                margin: EdgeInsets.only(left:5, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("TOTAL: \$ ${numberFormat(_clientOdersDetailController.total.value.toString())}",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                    ),),
                          
                  _clientOdersDetailController.order.statu=='EN CAMINO'?goToOrdersMap():Container()
                     ],
                    ),
                ),
               )
              ],
          );
     }


 
         Widget goToOrdersMap(){
                return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                       onPressed: ()=>_clientOdersDetailController.goToMapOrders(),
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        primary: Colors.redAccent
                       ),
                       child: Text('RASTREAR PEDIDO',
                       style: TextStyle(
                        color: Colors.white,fontSize: 13
                       ),)),
                      );
     }





}