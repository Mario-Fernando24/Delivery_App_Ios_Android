import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
import 'package:ios/src/utils/relative_time_util.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class RestaurantOrdersDetail extends StatelessWidget {
  RestaurantOrdersDetail({Key? key}) : super(key: key);

   RestaurantOdersDetailController restaurantOdersDetailController = Get.put(RestaurantOdersDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>  Scaffold(
       bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.4,
        color: Color.fromRGBO(245, 245, 245, 1),
        child: Column(
          children:[
           _dataDate(),
           _dataClient(),
           _dataDireccion(),
           totalToPay(context)
          ]
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black),
        title: Text('Order # ${restaurantOdersDetailController.order.id}',
        style: TextStyle(color: Colors.black)),
      ),
      body:  restaurantOdersDetailController.order.produc!.length>0 ?
            ListView(
              children: restaurantOdersDetailController.order.produc!.map((Product product) {
                 return _cardProduct(product);
              }).toList(),
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
          subtitle:Text('${restaurantOdersDetailController.order.cliente_json!.name ?? ''} ${restaurantOdersDetailController.order.cliente_json!.lastname ?? ''} - ${restaurantOdersDetailController.order.cliente_json!.phone ?? ''} '),
          trailing: Icon(
            Icons.person
          ),
        ),
      );
     }
     
     Widget _dataDireccion(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListTile(
          title: Text('Direccion de entrega'),
          subtitle:Text('${restaurantOdersDetailController.order.direccion_json!.direccion ?? ''} '),
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
          subtitle:Text('${ RelativeTimeUtil.getRelativeTime(restaurantOdersDetailController.order.timetamp ?? 0)} '),
          trailing: Icon(
            Icons.timer
          ),
        ),
      );
     }

     Widget totalToPay(BuildContext context){
          
          return  Column(
              children: [
              Divider(height: 1,color: Colors.grey),
              Container(
                margin: EdgeInsets.only(left:5, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("TOTAL: \$ ${numberFormat(restaurantOdersDetailController.total.value.toString())}",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                    ),),
                          
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                       onPressed: ()=>(){},
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10)
                       ),
                       child: Text('DESPACHAR ORDEN',
                       style: TextStyle(
                        color: Colors.black,fontSize: 13
                       ),)),
                      )
                     ],
                    ),
                ),
               )
              ],
          );
     }





}