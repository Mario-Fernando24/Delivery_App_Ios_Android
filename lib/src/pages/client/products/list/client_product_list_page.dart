import 'package:flutter/material.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_controller.dart';
import 'package:get/get.dart';
import 'package:ios/src/utils/theme/style.dart';
import 'package:ios/src/widget/no_data_widget.dart';



class ClientProductsListPage extends StatefulWidget {

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
   ClientProductsListController clientProductsListController = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {
     return Obx(()=> DefaultTabController(
      //para mostrar cuantas categorias voy a mostrar
      length: clientProductsListController.categoriess.length,
       child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            bottom: TabBar(
              isScrollable: true,
              indicatorColor:miTemaPrincipal,
              labelColor: Colors.black,
             // unselectedLabelColor: Colors.grey[600],
             unselectedLabelColor: Colors.white,
              tabs: List<Widget>.generate(clientProductsListController.categoriess.length, 
              (index) {
                return Tab(
                  child: Text(clientProductsListController.categoriess[index].name ?? ''),
                );
              }),

            ),
          ),
        ),
         body: TabBarView(
          children:clientProductsListController.categoriess.map((Category category){
            return FutureBuilder(
              //future es donde vamos a pasar el metodo que nos trae la data
              future: clientProductsListController.getProducts(category.id ?? '26'),
              builder: (context, AsyncSnapshot<List<Product>> snapshot){
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
                      return _cardProducts(snapshot.data![index],context);
                    }
                    );
                  }else{
                    return NoDataWidget(text: 'No hay productos disponibles',);
                  }
                 
                }else{
                  return NoDataWidget(text: 'No hay productos disponibles',);
                }
              }
              
              );
          }).toList()
          )
         ),
     ));
  }



  //Listar los productos por categoria
  Widget _cardProducts(Product product, BuildContext context){

    return  GestureDetector(
      onTap: ()=> clientProductsListController.openBottonSheet(product, context),
      child: Column(
        children: [
          Container(
          margin: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: ListTile(
            title: Text(product.name ?? '',
           ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(product.description ?? '',
                maxLines: 2,style: TextStyle(
                fontSize: 13
                ),
              ),
                SizedBox(height: 10),
                Text("\$"+ product.price.toString(),
                style: TextStyle(
                 fontWeight: FontWeight.bold,
                 color: Colors.black),
                 ),
                SizedBox(height: 20),
    
      
              ],
            ),
            leading: Container(
              height: 80,
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
            ),
          ),
        ),
    
        Divider(height: 1, color: Colors.grey[700], indent: 37, endIndent: 37,)
        ],
      ),
    );

  }


}