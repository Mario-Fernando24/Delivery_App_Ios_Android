import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/detail/client_product_detail_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

// ignore: must_be_immutable
class ClientProductDetailPage extends StatelessWidget {
  
   
   Product? product;
   late ClientProductsDetailController clientProductsListController;

    //contador del producto lo inicializo en 1 (el usuario minimo debe agregar un producto)
   var counter=0.obs;
   //precio del producto
   var price=0.0.obs;


   String noImagen="https://images.wondershare.com/recoverit/article/2020/05/cant-open-png-file-0.jpg";
    ClientProductDetailPage({@required this.product}){
    clientProductsListController = Get.put(ClientProductsDetailController());
   }

    
    
  @override
  Widget build(BuildContext context) {

    clientProductsListController.verificarIfProductAgregados(product!, price, counter);
    return  Obx(()=> Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        child: addButtonCart()
        ),
      body: Column(
        children: [
           _imageSlidershow(context),
           _textNameProduct(),
           _textDescriptionProduct(),
           _textPriceProduct(),
      
          ],
      )
    ));
  }

  //WIDGET DONDE MOSTRAREMOS LAS 3 IMAGENES QUE TENEMOS ALMACENADAS
  Widget _imageSlidershow(BuildContext context){
       return SafeArea(
        child: Stack(
           children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: CarouselImages(
                
                  height: MediaQuery.of(context).size.height * 0.42,
                  scaleFactor: 0.6,
                  listImages:  [  
                        product!.image1!=null? 
                        "${product!.image1.toString()}":noImagen,
                  
                        product!.image2!=null? 
                        "${product!.image2.toString()}":noImagen,

                        product!.image3!=null? 
                        "${product!.image3.toString()}":noImagen,

                        ],
                  borderRadius: 30.0,
                  cachedNetworkImage: true,
                  verticalAlignment: Alignment.topCenter,
                  onTap: (index){
                    print('Tapped on page $index');
                  },
                ),
            )
           ],
          )
        );
  }


  Widget _textNameProduct(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Text(product!.name!,
       style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black),),
    );
  }

   Widget _textDescriptionProduct(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Text(product!.description!,
       style: TextStyle(
        fontSize: 16
        ),),
    );
  }


     Widget _textPriceProduct(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Text('\$ ${product?.price.toString() ?? ''}',
       style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold
        ),),
    );
  }


  Widget addButtonCart(){
    return Column(
      children: [
        Divider(height: 1, color:Colors.grey[400],),
       
       Container(
        margin: EdgeInsets.only(left: 30,right: 30,top: 30),
         child: Row(
           children: [
            ElevatedButton(
            onPressed: ()=>clientProductsListController.removeItem(product!, price, counter),
            child: Text("-",style: 
            TextStyle(
              color: Colors.black,
              fontSize: 22
            ),),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(40, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25)
                )
              )
            ),),
         
          ElevatedButton(
            onPressed: (){},
            child: Text('${counter.value}',style: 
            TextStyle(
              color: Colors.black,
              fontSize: 22
            ),),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(40, 37)
              
             ),
            ),



            


            ElevatedButton(
            onPressed: ()=>clientProductsListController.addItem(product!, price, counter),
            child: Text("+",style: 
            TextStyle(
              color: Colors.black,
              fontSize: 22
            ),),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              minimumSize: Size(40, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25)
                )
              )
            ),),


          //el resto que sobre
          Spacer(),
          ElevatedButton(
            onPressed: ()=>clientProductsListController.addBolsa(product!, price, counter),
            child: Text("Agregar  ${(price.value).toStringAsFixed(2)}",style: 
            TextStyle(
              color: Colors.black,
              fontSize: 15
            ),),
            style: ElevatedButton.styleFrom(
              primary: miTemaPrincipal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              )
            ),),



            


            
      ],
         ),
       )
      ]
    );
  }

}