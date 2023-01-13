import 'package:flutter/material.dart';
import 'package:ios/src/pages/client/products/home/client_home_controller.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_page.dart';
import 'package:ios/src/pages/client/products/orders/list/client_orders_list_page.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_page.dart';
import 'package:ios/src/utils/custom_animated_bottom_bar.dart';
import 'package:ios/src/utils/theme/style.dart';


class ClientHomePage extends StatefulWidget {

  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
   ClientHomeController clientHomeController = Get.put(ClientHomeController());

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      bottomNavigationBar:_bottonBar() ,
       body: Obx(()=> IndexedStack(
        index: clientHomeController.indexTab.value,
        children: [
          ClientProductsListPage(),
          ClientOdersListPage(), 
          ClientProfileInfoPage()
        ],
       )
       ),
    );
  }

// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Client Orders List"),
//             ElevatedButton(
//             onPressed: () =>clientProductsListController.singOut(),
//             child: Text('Cerrar sessión',style: TextStyle(color: Colors.black),),
//           ),
//           ],
//         ),
//        ),

  Widget _bottonBar(){
    return Obx(()=> CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: miTemaPrincipal,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: clientHomeController.indexTab.value,
      //cambiar el valor cuando el usuario cambia
      onItemSelected: (index)=>clientHomeController.changeTam(index),
      items: [
        BottomNavyBarItem(
         icon:Icon(Icons.home),
         title: Text("Productos"),
         activeColor: Colors.white,
         inactiveColor: Colors.black,
         ),
         
        BottomNavyBarItem(
         icon:Icon(Icons.list),
         title: Text("Mis pedidos"),
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