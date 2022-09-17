import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/pages/client/products/home/client_home_page.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_page.dart';
import 'package:ios/src/pages/client/products/orders/create/client_orders_create_page.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_page.dart';
import 'package:ios/src/pages/client/products/profile/update/client_profile_update_page.dart';
import 'package:ios/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:ios/src/pages/home/home_page.dart';
import 'package:ios/src/pages/login/login_page.dart';
import 'package:ios/src/pages/register/register_page.dart';
import 'package:ios/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:ios/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:ios/src/pages/roles/roles_page.dart';
import 'package:ios/src/utils/theme/style.dart';


User myUserSession = User.fromJson(GetStorage().read('user') ?? {});
void main() async{
  //inicializamos storage
  await GetStorage.init();
 
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Mario Domicilio",
      debugShowCheckedModeBanner: false,
      //ruta inicial validamos que si el usuario es diferente de null y tiene mas de dos roles que mande para que decida porquenrol desea iniciar sesion
      initialRoute: myUserSession.id!='null' ? myUserSession.roles!.length >1 ?'/roles' : '/client/home':'',
      getPages: [
        GetPage(name: '/', page: ()=>LoginPage()),
        GetPage(name: '/register', page: ()=>RegisterPage()),
        GetPage(name: '/home', page: ()=>HomePage()),
        GetPage(name: '/roles', page: ()=>RolesPage()),
        GetPage(name: '/restaurant/home', page: ()=>RestaurantHomePage()),
        GetPage(name: '/restaurant/orders/list', page: ()=>RestaurantOdersListPage()),
        GetPage(name: '/delivery/orders/list', page: ()=>DeliveryOdersListPage()),
        GetPage(name: '/client/home', page: ()=>ClientHomePage()),
        GetPage(name: '/client/products/list', page: ()=>ClientProductsListPage()),
        GetPage(name: '/client/profile/info', page: ()=>ClientProfileInfoPage()),
        GetPage(name: '/client/profile/update', page: ()=>ClientProfileUpdatePage()),
        GetPage(name: '/client/products/orders', page: ()=>ClientOrdersCreatePage()),
        
        
        //HOME      
      ],
      theme: ThemeData(
        primaryColor: miTemaPrincipal,
        colorScheme: ColorScheme(
          primary: miTemaPrincipal,
          secondary: Colors.redAccent,
          brightness: Brightness.light,
          onBackground: Colors.grey,
          onPrimary:  Colors.grey,
          surface:  Colors.grey,
          onSurface:  Colors.grey,
          error:  Colors.grey,
          onError:  Colors.grey,
          onSecondary:  Colors.grey,
          background:  Colors.grey, 
          secondaryVariant: Colors.grey,
          primaryVariant: Colors.grey,
        )
      ),
      navigatorKey: Get.key,
    );
  }
}