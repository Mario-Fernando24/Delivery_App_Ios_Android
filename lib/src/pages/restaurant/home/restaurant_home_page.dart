import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_page.dart';
import 'package:ios/src/pages/restaurant/categories/create/restaurant_categories_create.dart';
import 'package:ios/src/pages/restaurant/categories/list/restaurant_category_list_page.dart';
import 'package:ios/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:ios/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:ios/src/pages/restaurant/products/create/restaurant_products_create.dart';
import 'package:ios/src/utils/custom_animated_bottom_bar.dart';
import 'package:ios/src/utils/theme/style.dart';


class RestaurantHomePage extends StatefulWidget {

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
   RestaurantHomeController restaurantHomeController = Get.put(RestaurantHomeController());

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      bottomNavigationBar:_bottonBar() ,
       body: Obx(()=> IndexedStack(
        index: restaurantHomeController.indexTab.value,
        children: [
          RestaurantOdersListPage(),
         // RestaurantCategoriesCreatePage(),
          RestaurantCategoryListPage(),
          RestaurantProductoCreatePage(), 
          ClientProfileInfoPage()
        ],
       )
       ),
    );
  }


  Widget _bottonBar(){
    return Obx(()=> CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: miTemaPrincipal,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: restaurantHomeController.indexTab.value,
      //cambiar el valor cuando el usuario cambia
      onItemSelected: (index)=>restaurantHomeController.changeTam(index),
      items: [
        BottomNavyBarItem(
         icon:Icon(Icons.list),
         title: Text("Pedidos"),
         activeColor: Colors.white,
         inactiveColor: Colors.black,
         ),
         
        BottomNavyBarItem(
         icon:Icon(Icons.category),
         title: Text("Categorias"),
         activeColor: Colors.white,
         inactiveColor: Colors.black,),

        BottomNavyBarItem(
         icon:Icon(Icons.restaurant),
         title: Text("Productos"),
         activeColor: Colors.white,
         inactiveColor: Colors.black,),

         
        BottomNavyBarItem(
         icon:Icon(Icons.person),
         title: Text("Perfil"),
         activeColor: Colors.white,
         inactiveColor: Colors.black,),
      ],
    ),
      );
  }
}