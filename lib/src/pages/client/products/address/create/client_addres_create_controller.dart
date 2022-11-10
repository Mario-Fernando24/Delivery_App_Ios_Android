import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAddresCreateController extends GetxController{

    TextEditingController addressController = TextEditingController();
    TextEditingController nombreBarrioController = TextEditingController();
    TextEditingController puntoReferenciaController = TextEditingController();


  void goToAddresCreate(){
    Get.toNamed('/client/addres/create');
  }


}
