import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Address.dart';
import 'package:ios/src/providers/address_providers.dart';

class ClientAddresListController extends GetxController{

     List<Address> address =<Address>[].obs;
     AddressProviders addressProviders = AddressProviders();

     var radioValue=0.obs;

    ClientAddresListController(){
      print('LA DIRECCION DE SESSION  ${GetStorage().read('direccion')}');
    }


    void goToAddresCreate(){
      Get.toNamed('/client/addres/create');
    }

  

   Future<List<Address>> getAddress() async{
      
        address = await addressProviders.getByfindId();
     print('11111111111111111111111111111111111111111111111111111');
       if(GetStorage().read('direccion')!=null){
       Address a = Address.fromJson(GetStorage().read('direccion'));
       
     print('22222222222222222222222222222222222222222222222222222');
 
      // //preguntamos si la direccion de session es igual a la que listamos de nuestra base de dato
        int index=address.indexWhere((dire) => dire.id==a.id);
     print('3333333333333333333333333333333333333333333333333333');
      //   //si esto es true coincide
         if(index!=-1){
           radioValue.value=index;
         }}
    return address;
  }

  void selRadioChamge(int? value){
    radioValue.value=value!;
    GetStorage().write('direccion',address[value].toJson());
    update();
    print("Mario fernando posiction${value}");
  }
}
