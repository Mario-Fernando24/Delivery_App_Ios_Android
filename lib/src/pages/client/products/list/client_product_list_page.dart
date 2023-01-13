import 'package:flutter/material.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_controller.dart';
import 'package:get/get.dart';
import 'package:ios/src/utils/expresiones_regulares.dart';
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
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: Container(
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.topCenter,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  searchTextFiel(context),
                  _iconShoppingBag()
                ],
              ),
            ),
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
              future: clientProductsListController.getProducts(category.id ?? '26',clientProductsListController.productName.value),
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
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          child: ListTile(
            title: Text(product.name ?? '',
                maxLines: 2,style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal
                ),
           ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(product.description ?? '',
                maxLines: 2,style: TextStyle(
                fontSize: 12
                ),
              ),
                SizedBox(height: 10),

                Row(
                  children: [
                  Text("\$ "+ numberFormat(product.price.toString()),
                  style: TextStyle(
                   fontWeight: FontWeight.normal,
                   color: Colors.black,
                    fontSize: 13),
                   ),
                   
                   ]
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


  Widget _iconShoppingBag(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: clientProductsListController.item.value>0 ?  Stack(
          children: [
            IconButton(onPressed: ()=>clientProductsListController.goToOrdersCreate(),
             icon: Icon(Icons.shopping_bag_outlined,
             size: 33,)
             ),
             Positioned(
              right: 7,
              top: 12,
              child: 
               Container(
                  width: 17,
                  height: 17,
                  alignment: Alignment.center,
                  child: Text('${clientProductsListController.item.value}',style: TextStyle(fontSize: 12.0,
                  ),) ,
                  decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.all(Radius.circular(30.0))
                  ),
             ),
            )
          ],
        ):  Stack(
          children: [
            IconButton(onPressed: ()=>clientProductsListController.goToOrdersCreate(),
             icon: Icon(Icons.shopping_bag_outlined,
             size: 33,)
             ),
          ],
        ) ,
      ),
    );
  }

  Widget searchTextFiel(BuildContext context){
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width*0.76,
        child: TextField(
          onChanged: clientProductsListController.onChangeText,
          decoration: InputDecoration(
            hintText: 'Buscar producto',
            suffixIcon: Icon(Icons.search, 
            color: Colors.grey,),
            hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey)
            ),
    
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey)
            ),
            contentPadding: EdgeInsets.all(15)
    
          ),
        ),
      ),
    );
  }

  


}