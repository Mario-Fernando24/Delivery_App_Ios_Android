import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/models/Category.dart';
import 'package:ios/src/pages/restaurant/categories/list/restaurant_category_list_controller.dart';
import 'package:ios/src/widget/no_data_widget.dart';

class RestaurantCategoryListPage extends StatelessWidget {
   RestaurantCategoryListController restaurantCategoryListController = Get.put(RestaurantCategoryListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: Text("Listas categorias", style: TextStyle(
            color: Colors.white
          ),
          ),
        ),
      ),
       body:  Stack(
        children: [
          // _textTitle(),
          _listCategory(context)
      ],
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: ()=> restaurantCategoryListController.goToHomeRestaurantCreate(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }


    Widget _textTitle(){

    return Container(
      margin: EdgeInsets.only(top: 30, left: 30.0),
      child: Text( 'Categorias', 
      style: TextStyle(
        color: Colors.black,
        fontSize: 19, 
        fontWeight: FontWeight.bold),
      ),
    );
  }

    Widget _listCategory(BuildContext context){
      return  Container(
        margin: EdgeInsets.only(top: 0.0,),
        child: FutureBuilder(
        future: restaurantCategoryListController.getCategories(),
        builder: (context, AsyncSnapshot<List<Category>> snapshot){
         
          //si tiene informacion
          if(snapshot.hasData){
            //si la data no este vacia
            if(snapshot.data!.isNotEmpty){
             
               return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (_,index){
                  
                    return _cardCategory(snapshot.data![index], index,context);
                });
            }else{
               return Center(
             child: NoDataWidget(text: 'No hay categoria',)
            );
            }

          }else{
            return Center(
             child: NoDataWidget(text: 'No hay categoria',)
            );
          }

        },
        ),
      );
  }




    Widget _cardCategory(Category category, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () => {},
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 2,
                  color: Color.fromRGBO(186, 186, 186, 0.25),
                )
              ]),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    // width: 200,
                    margin: EdgeInsets.only(left: 20, top: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              category.name ?? '',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            IconButton(
                                icon: new Icon(Icons.edit_outlined),
                                highlightColor: Colors.pink,
                                onPressed:() => restaurantCategoryListController.openBottonSheetCategory(category, context),
                              ),
                            SizedBox(width: 14),
                          ],
                        ),
                        

                        Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, top: 2.0, bottom: 10.0),
                          child: Text(
                            category.descripcion ?? '',
                            maxLines: 4,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 29, 14, 14)),
                          ),
                        ),
                      ],
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}