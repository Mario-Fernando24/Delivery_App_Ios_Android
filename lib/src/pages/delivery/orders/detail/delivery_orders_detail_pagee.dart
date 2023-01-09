import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
import 'package:ios/src/utils/relative_time_util.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class DeliveryOrdersDetailPage extends StatelessWidget {
  DeliveryOrdersDetailPage({Key? key}) : super(key: key);

   DeliveryOdersDetailController deliveryOdersDetailController = Get.put(DeliveryOdersDetailController());

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
             _dataClient(),
             _dataDireccion(),
             _domiciliarioAsignado(),
             totalToPay(context)
            ]
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black),
        title: Text('Order # ${deliveryOdersDetailController.order.id}',
        style: TextStyle(color: Colors.black)),
      ),
      body:  deliveryOdersDetailController.order.produc!.length>0 ?
            Container(
              margin: EdgeInsets.only(bottom: 13.0),
              child: ListView(
                children: deliveryOdersDetailController.order.produc!.map((Product product) {
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
                Text('Cantidad: ${product.quantity ?? ''}',style: TextStyle(fontSize: 12.0),),
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


     Widget _dataClient(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Cliente y telefono'),
          subtitle:Text('${deliveryOdersDetailController.order.cliente_json!.name ?? ''} ${deliveryOdersDetailController.order.cliente_json!.lastname ?? ''}  -  ${deliveryOdersDetailController.order.cliente_json!.phone ?? ''} '),
          trailing: Icon(
            Icons.person
          ),
        ),
      );
     }


       Widget _domiciliarioAsignado(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Domiciliario asignado'),
          subtitle:Text('${deliveryOdersDetailController.order.domiciliario_json!.name ?? ''} ${deliveryOdersDetailController.order.domiciliario_json!.lastname ?? ''}  -  ${deliveryOdersDetailController.order.domiciliario_json!.phone ?? ''} '),
          trailing: Icon(
            Icons.delivery_dining
          ),
        ),
      );
     }
     
     Widget _dataDireccion(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Direccion de entrega'),
          subtitle:Text('${deliveryOdersDetailController.order.direccion_json!.direccion ?? ''} '),
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
          subtitle:Text('${ RelativeTimeUtil.getRelativeTime(deliveryOdersDetailController.order.timetamp ?? 0)} '),
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
                    Text("TOTAL: \$ ${numberFormat(deliveryOdersDetailController.total.value.toString())}",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                    ),),
                          
                   deliveryOdersDetailController.order.statu=='DESPACHADO'? updateOrders(context):deliveryOdersDetailController.order.statu=='EN CAMINO'?goToOrdersMap():Container()
                     ],
                    ),
                ),
               )
              ],
          );
     }


     Widget updateOrders(BuildContext context){
      return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                       onPressed: ()=>deliveryOdersDetailController.updateOrdenIniciarEntrega(deliveryOdersDetailController.order.id, context),
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        primary: Colors.green
                       ),
                       child: Text('INICIAR ENTREGA',
                       style: TextStyle(
                        color: Colors.white,fontSize: 13
                       ),)),
                      );
     }


         Widget goToOrdersMap(){
                return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                       onPressed: ()=>deliveryOdersDetailController.goToMapOrders(),
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        primary: Colors.lightGreenAccent
                       ),
                       child: Text('Volver al mapa',
                       style: TextStyle(
                        color: Colors.black,fontSize: 13
                       ),)),
                      );
     }





}