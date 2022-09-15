import 'package:flutter/material.dart';
import 'package:ios/src/pages/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () =>homeController.singOut(),
          child: Text('Cerrar sessión',style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}