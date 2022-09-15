import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ios/src/models/Product.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientProductsDetailController extends GetxController{

   Product? product;
   //contador del producto lo inicializo en 1 (el usuario minimo debe agregar un producto)
   var counter=1.obs;
   //precio del producto
   var price=0.0.obs;


   List<Product> selectProducts =[];

   ClientProductsDetailController(Product product){
     this.product=product;
     price.value=product.price ?? 0.0;
     //le pasamos a la lista el getStorage para que se llene
     //obtenemos los producto guardados en el GESTORAGE DE LA SESSIÓN
     if(GetStorage().read('bolsa_compra')!=null){
       //validar si gestorage es una list de producto
       if(GetStorage().read('bolsa_compra') is List<Product>){
         selectProducts=GetStorage().read('bolsa_compra');
       }else{
          selectProducts=Product.fromJsonList(GetStorage().read('bolsa_compra'));
       }
         selectProducts.forEach((element) {
           print(element.toJson());
          });
     }
   }


      void addBolsa(){
        //para saber si el producto ya fue agregado a la bolsa GESTORAJE
        int index=selectProducts.indexWhere((productt) => productt.id==product?.id);

        //el producto aun no ha sido agregado
        if(index==-1){
          print("Mariooooooo"+index.toString());
           if(product?.quantity==null){
              //le asignamos la cantidad selecionada por el usuario
              product?.quantity=1;
           }
           selectProducts.add(product!);
        }else{
          
          print("Muñozzzzzz"+index.toString());
          //el producto ya ha sido agregado en el GESTORAGE
          selectProducts[index].quantity=counter.value;
        }
        GetStorage().write('bolsa_compra', selectProducts);
      // Fluttertoast.showToast(msg: "Producto agregado");
    

      }
   //para agregar un item
   void addItem(){
    counter.value=counter.value+1;
    price.value=product!.price!* counter.value;
   }
   //metodo para remover un item y actualizar el precio
    void removeItem(){
      if(counter.value>0){
        counter.value=counter.value-1;
        price.value=product!.price!* counter.value;
      }


   }
}
