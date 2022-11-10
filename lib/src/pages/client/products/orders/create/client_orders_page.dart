import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/orders/create/client_orders_controllers.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
import 'package:ios/src/widget/no_data_widget.dart';


class ClientOrdersPage extends StatelessWidget {
  
   ClientOrdersController _clientOrdersController= Get.put(ClientOrdersController());

  @override
  Widget build(BuildContext context) {
    
    return  Obx(()=> Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: Color.fromRGBO(245, 245, 245, 1),
        child: totalToPay(context),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData( 
          color: Colors.black
        ),
        title: Text("Mi orden", 
        style: TextStyle(
          color: Colors.black
        ),),
      ),
      //preguntamos si la lista de producto tiene almenos un producto save 
      body: _clientOrdersController.selectProducts.length>0 ?
            ListView(
              children: _clientOrdersController.selectProducts.map((Product product) {
                 return _cardProduct(product);
              }).toList(),
            ) : Center(child: NoDataWidget(text: "No hay ningun producto aun",))
    ));
  }


  //W
  Widget _imageProduct(Product product){

    return Container(
              height: 70,
              width: 70,
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


     Widget totalToPay(BuildContext context){
          
          return  Column(
            children: [
              Divider(height: 1,color: Colors.grey),

            Container(
              margin: EdgeInsets.only(left:5, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("TOTAL: \$ ${_clientOrdersController.total.value}",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),),

                Container(

                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                   onPressed: ()=>_clientOrdersController.goToListAddres(),
                   style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10)
                   ),
                   child: Text('CONFIRMAR ORDEN',
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
                Text(product.name ?? '', style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 7),
                _buttonsAddOrRemove(product),
              ],
             ),

             // Spacer ocupar el resto de la pantalla extremo
             Spacer(),
             Column(
              children: [
                _textPrice(product),
                _iconDelete(product)
              ],
             )
          ],
          ),
      ); 
     }


  Widget _iconDelete(Product product){
    return IconButton(
      onPressed: ()=>_clientOrdersController.deleteProduct(product),
     icon: Icon(
      Icons.delete,
      color: Colors.red,
      ),
     );
  }

  Widget _textPrice(Product product){
       return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          '\$ ${  product.price! * product.quantity! }',
          style: TextStyle(color: Colors.grey,
          fontWeight: FontWeight.normal),
        ),
       );
  }


  Widget _buttonsAddOrRemove(Product product ){

      return Row(
        children: [
          GestureDetector(
            onTap: ()=>_clientOrdersController.removeItem(product),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              ),
              child: Text('-'),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            color: Colors.grey[200],
            child: Text('${product.quantity ?? 0}'),

          ),


           GestureDetector(
            onTap: ()=>_clientOrdersController.addItem(product),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
              ),
              child: Text('+'),
            ),
          ),
        ],
      );
  }



}