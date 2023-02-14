import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificacionProviders{


   AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', 
    importance: Importance.high,
  );

   FlutterLocalNotificationsPlugin plugin=FlutterLocalNotificationsPlugin() ;



  //inicializamos las variable
   void initPushNotification()async{

        await plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    }

   

  void onMessageListener() async{

     FirebaseMessaging.instance
                    .getInitialMessage()
                    .then((RemoteMessage? message) {
                  if (message != null) {
                 
                  }
                });



  //DONDE SE MUESTRA LA APLICACION EN PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       RemoteNotification? notication = message.notification;
       AndroidNotification? android = message.notification?.android;

       if(notication!=null && android!=null){
        plugin.show(
          notication.hashCode,
          notication.title,
          notication.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background'
            )
          )
        ); 
       }

    });



      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
     
    });
  

  
  }
}