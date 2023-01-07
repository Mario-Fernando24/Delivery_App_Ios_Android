import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
import 'package:ios/src/utils/relative_time_util.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class RestaurantOrdersDetail extends StatelessWidget {
  RestaurantOrdersDetail({Key? key}) : super(key: key);

   RestaurantOdersDetailController restaurantOdersDetailController = Get.put(RestaurantOdersDetailController());

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
        title: Text('Order # ${restaurantOdersDetailController.order.id}',
        style: TextStyle(color: Colors.black)),
      ),
      body:  restaurantOdersDetailController.order.produc!.length>0 ?
            Container(
              margin: EdgeInsets.only(bottom: 13.0),
              child: ListView(
                children: restaurantOdersDetailController.order.produc!.map((Product product) {
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
          subtitle:Text('${restaurantOdersDetailController.order.cliente_json!.name ?? ''} ${restaurantOdersDetailController.order.cliente_json!.lastname ?? ''}  -  ${restaurantOdersDetailController.order.cliente_json!.phone ?? ''} '),
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
          subtitle:Text('${restaurantOdersDetailController.order.domiciliario_json!.name ?? ''} ${restaurantOdersDetailController.order.domiciliario_json!.lastname ?? ''}  -  ${restaurantOdersDetailController.order.domiciliario_json!.phone ?? ''} '),
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



      Widget _dropDownDomiciliario(List<User> usuario) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
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
                  'Seleccionar domiciliario',
                  style: TextStyle(

                    fontSize: 15
                  ),
                ),
                items: _dropdownMenuItem(usuario),
                value: restaurantOdersDetailController.id_usuario.value == '' ? null : restaurantOdersDetailController.id_usuario.value,
                onChanged: (option) {
                  print('Opcion seleccionada ${option}');
                  restaurantOdersDetailController.id_usuario.value = option.toString();
                },
              ),
            );
          }

        List<DropdownMenuItem<String>> _dropdownMenuItem(List<User> users){
          List<DropdownMenuItem<String>> list =[];
          users.forEach((user) {
                list.add(DropdownMenuItem(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: FadeInImage(
                          image: user.image!=null? NetworkImage(user.image!) :
                          AssetImage('assets/img/no-image.png') as ImageProvider,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 50),
                          placeholder: AssetImage('assets/img/no-image.png'),),
                      ),
                      SizedBox(width: 10.0,),
                      Text('${user.name ?? ''} ${user.lastname ?? ''} ' ),
                    ],
                  ),
                  value: user.id,
                  ));
          });

          return list;
        }

     Widget totalToPay(BuildContext context){
          
          return  Column(
              children: [
              Divider(height: 1,color: Colors.grey[400]),
              restaurantOdersDetailController.order.statu=='PAGADO'? Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 30.0, top: 10),
                child: Text('ASIGNAR DOMICILIARIO',style: TextStyle(fontStyle: FontStyle.italic, color:miTemaPrincipal, fontWeight: FontWeight.bold ),)
                ):Container(),
             restaurantOdersDetailController.order.statu=='PAGADO'? _dropDownDomiciliario(restaurantOdersDetailController.usuarioDomiciliario):Container(),
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
                          
                   restaurantOdersDetailController.order.statu=='PAGADO'? Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                       onPressed: ()=>restaurantOdersDetailController.updateOrdenDespachada(restaurantOdersDetailController.order.id, context),
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10)
                       ),
                       child: Text('DESPACHAR ORDEN',
                       style: TextStyle(
                        color: Colors.black,fontSize: 13
                       ),)),
                      ):Container()
                     ],
                    ),
                ),
               )
              ],
          );
     }





}