import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/environment/routes.dart';
import 'package:ios/src/models/User.dart';
import 'package:ios/src/pages/client/products/address/create/client_addres_create_page.dart';
import 'package:ios/src/pages/client/products/address/list/client_addres_list_page.dart';
import 'package:ios/src/pages/client/products/home/client_home_page.dart';
import 'package:ios/src/pages/client/products/list/client_product_list_page.dart';
import 'package:ios/src/pages/client/products/orders/create/client_orders_page.dart';
import 'package:ios/src/pages/client/products/orders/detail/client_orders_detail_pagee.dart';
import 'package:ios/src/pages/client/products/orders/list/client_orders_list_page.dart';
import 'package:ios/src/pages/client/products/orders/map/client_orders_map_page.dart';
import 'package:ios/src/pages/client/products/orders/payments/create/client_payments_create_page.dart';
import 'package:ios/src/pages/client/products/orders/payments/num_cuotas_payments/client_payments_numcuotas_page.dart';
import 'package:ios/src/pages/client/products/orders/payments/status/client_payments_status_page.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_page.dart';
import 'package:ios/src/pages/client/products/profile/update/client_profile_update_page.dart';
import 'package:ios/src/pages/delivery/home/delivery_home_page.dart';
import 'package:ios/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:ios/src/pages/home/home_page.dart';
import 'package:ios/src/pages/login/login_page.dart';
import 'package:ios/src/pages/register/register_page.dart';
import 'package:ios/src/pages/restaurant/categories/create/restaurant_categories_create.dart';
import 'package:ios/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:ios/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:ios/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:ios/src/pages/roles/roles_page.dart';
import 'package:ios/src/providers/push_notification_providers.dart';
import 'package:ios/src/utils/firebase_config.dart';
import 'package:ios/src/utils/theme/style.dart';

import 'src/pages/delivery/orders/detail/delivery_orders_detail_pagee.dart';
import 'src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'src/pages/restaurant/categories/list/restaurant_category_list_page.dart';
import 'src/pages/restaurant/categories/list/updateCategory.dart';


PushNotificacionProviders pushNotificacionProviders = PushNotificacionProviders();
User myUserSession = User.fromJson(GetStorage().read('user') ?? {});

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  print('Recibiendo notificacion en segundo plano ${message.messageId}');
}


void main() async{
  //inicializamos storage
  await GetStorage.init();
    //notificaciones primer plano
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
    //recibir las notificaciones en segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //empezara a escuchar las notificaciones
    pushNotificacionProviders.initPushNotification();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ejecutar el metodo 
        pushNotificacionProviders.onMessageListener();

  }

  
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
        GetPage(name: '/restaurant/category/list', page: ()=>RestaurantCategoryListPage()),
        GetPage(name: '/restaurant/category/create', page: ()=>RestaurantCategoriesCreatePage()),
        GetPage(name: '/restaurant/category/update', page: ()=>UpdateCategory()),
        GetPage(name: '/delivery/home', page: ()=>DeliveryHomePage()),
        GetPage(name: '/delivery/orders/list', page: ()=>DeliveryOdersListPage()),
        GetPage(name: ROUTES.delivery_orders_detail, page: ()=>DeliveryOrdersDetailPage()),
        GetPage(name: '/delivery/orders/map', page: ()=>DeliveryOrderMapPage()),
        GetPage(name: ROUTES.restaurant_orders_detail, page: ()=>RestaurantOrdersDetail()),
        GetPage(name: '/client/home', page: ()=>ClientHomePage()),
        GetPage(name: '/client/products/list', page: ()=>ClientProductsListPage()),
        GetPage(name: '/client/profile/info', page: ()=>ClientProfileInfoPage()),
        GetPage(name: '/client/profile/update', page: ()=>ClientProfileUpdatePage()),
        GetPage(name: '/client/products/orders', page: ()=>ClientOrdersPage()),
        GetPage(name: '/client/addres/create', page: ()=>ClientAddresCreatePage()),
        GetPage(name: '/client/orders/list', page: ()=>ClientOdersListPage()),
        GetPage(name: ROUTES.client_orders_detail, page: ()=>ClientOrdersDetailPage()),
        GetPage(name: '/client/orders/map', page: ()=>ClientOrderMapPage()),

        GetPage(name: ROUTES.listarAddres, page: ()=>ClientAddresListPage()),  
        
        GetPage(name: ROUTES.payments_create, page: ()=>ClientPaymentsCreatePage()),  
        GetPage(name: '/client/orders/payments/numcuota', page: ()=>ClientPaymentsNumCuotasPage()),
        GetPage(name: '/client/orders/payments/status', page: ()=>ClientPaymentStatusPage()),

        
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