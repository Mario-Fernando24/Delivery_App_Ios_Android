import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Order.dart';
import 'package:ios/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:ios/src/utils/relative_time_util.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class RestaurantOdersListPage extends StatelessWidget {
  
   RestaurantOdersListController restaurantOdersListController = Get.put(RestaurantOdersListController());

  @override
  
  @override
  Widget build(BuildContext context) {
     return Obx(()=> DefaultTabController(
      //para mostrar cuantas tipos de orden voy a mostrar
      length: restaurantOdersListController.status.length,
       child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            bottom: TabBar(
              isScrollable: true,
              indicatorColor:miTemaPrincipal,
              labelColor: Colors.black,
             unselectedLabelColor: Colors.white,
              tabs: List<Widget>.generate(restaurantOdersListController.status.length, 
              (index) {
                return Tab(
                  child: Text(restaurantOdersListController.status[index]),
                );
              }),

            ),
          ),
        ),
         body: TabBarView(
          children:restaurantOdersListController.status.map((String status){
            return FutureBuilder(
              //future es donde vamos a pasar el metodo que nos trae la data
              future: restaurantOdersListController.getOrders(status),
              builder: (context, AsyncSnapshot<List<Order>> snapshot){
                //preguntamos si viene informacion en la data
                if(snapshot.hasData){
                  if(snapshot.data!.length>0){
                  //me permite ubicar elemento uno debajo del otro
                  //GridBuilder con este widge espe 
                 // return ListView.builder(
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_,index){
                      //le envio por parametro un producto en especifico
                      return _cardOrders(snapshot.data![index],context);
                    }
                    );
                  }else{
                    return Center(child: NoDataWidget(text: 'No hay ordenes disponibles',));
                  }
                 
                }else{
                  return Center(child: NoDataWidget(text: 'No hay ordenes disponibles',));
                }
              }
              
              );
          }).toList()
          )
         ),
     ));
  }
  
  Widget _cardOrders(Order order, BuildContext context) {

      return GestureDetector(
        onTap: ()=> restaurantOdersListController.goToDetailOrden(order),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          height: 150.0,
          child: Card( 
            elevation: 3.0,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 30.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: miTemaPrincipal,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)
                          )
                        ),
                        child: Container(
                            margin: EdgeInsets.only(top: 5.0),
                          child: Text('  Orden #  ${order.id}',textAlign: TextAlign.center,
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text('Fecha  ${RelativeTimeUtil.getRelativeTime(order.timetamp ?? 0) }' )
                            ),
                          
                    
                            Container(
                            margin: EdgeInsets.only(top: 5.0),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text('Cliente: ${order.cliente_json?.name }  ${order.cliente_json?.lastname }'  )
                            ),
                    
                            Container(
                            margin: EdgeInsets.only(top: 5.0),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text('Entregar en: ${order.direccion_json?.direccion }' )
                            ),
                        
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
      );
  }
}