import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Product.dart';
import 'package:ios/src/models/mercado_pago_card_holder.dart';
import 'package:ios/src/models/mercado_pago_card_token.dart';
import 'package:ios/src/models/mercado_pago_installment.dart';
import 'package:ios/src/providers/mercado_pago_providers.dart';

class ClientPaymentsNumCuotasController extends GetxController{


  MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(Get.arguments['card_token']);

     MercadoPagoProviders mercadoPagoProviders = MercadoPagoProviders();
     var total=0.0.obs;
     var selectProducts =<Product>[].obs;
     var numCuotaaaa = ''.obs;

     //lista donde guardo la lista de las cuota de cada tarjeta
     List<MercadoPagoInstallment> numCuotaList = <MercadoPagoInstallment>[].obs;

     
    //obtengo en el constructor los producto guardados en el GetStorage y lo almaceno en una lista de producto
     ClientPaymentsNumCuotasController(){
     
       if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
            //le asigno el array que esta en el Gestorage y se lo asigno a la variable result
            var result =GetStorage().read('bolsa_compra'); 
            print("*********************************************************************");
            // print("mario fernando"+result);
            print("*********************************************************************");
            // vacio la lista de producto
            selectProducts.clear();
            // agrego los producto del result a la list de produto donde estan todos los productos que escogio el usuario
            selectProducts.addAll(result);
          
          }else{
            var result =Product.fromJsonList(GetStorage().read('bolsa_compra'));
            selectProducts.clear();
            selectProducts.addAll(result);
       }
       getTotal();
       getNumCuota();
      
      }
    }


    void getNumCuota() async {

      if(cardToken.firstSixDigits!=null){
             
       var result = await mercadoPagoProviders.getNumCuota(cardToken.firstSixDigits!, total.value);

       print('RESULTADO:  ${result.payerCosts!}');
       if(result.payerCosts!=null){
           numCuotaList.clear();
           numCuotaList.addAll(result.payerCosts!);
       }
       


        //numCuotaList
      }
                                           
 
    }

      void getTotal(){
            total.value=0.0;
            //recorremos la lista con un for
              selectProducts.forEach((product) {
              total.value+=total.value+(product.quantity! * product.price!);
            });
          }
}