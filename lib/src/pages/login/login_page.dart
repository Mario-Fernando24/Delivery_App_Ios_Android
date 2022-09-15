import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/login/login_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class LoginPage extends StatelessWidget {
  
  //instanciamos el controlador login
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        child: _textNoTengoCuenta(),
      ),
      body: Stack(children: [
          
        _backgruoundCover(context),
        _boxForm(context),
        Column(children: [
        _imageCover(),
        _textApp()
        ],)
      ],),
    );
  }

Widget _backgruoundCover(BuildContext context){
   return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height*0.4,
    color: miTemaPrincipal,
   );
}

Widget _textApp(){
  return Text("Burger king"
  ,style: TextStyle(fontWeight:FontWeight.bold ,
   fontSize: 20,
   color: Colors.white),);
}

Widget _imageCover(){
  return SafeArea(
    child: Container(
      margin: EdgeInsets.only(top: 20, bottom: 15),
      alignment: Alignment.center,
      child: logoApp
      ),
  );
}


Widget _textNoTengoCuenta(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Text("No tienes cuenta",style: TextStyle(color: Colors.black,
       fontWeight: FontWeight.bold,
      fontSize: 17),),

      SizedBox(width: 10,),

      GestureDetector(
        onTap:()=>loginController.goToRegisterPage(),
        child: Text("Registate aqui",style: TextStyle(color: miTemaPrincipal,
        fontWeight: FontWeight.bold,
        fontSize: 17),),
      )
    ],
  );
}



Widget _boxForm(BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.34, left: 30, right: 30),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black54,
          blurRadius: 15,
          offset: Offset(0.0,75)
        )
      ]
    ),
    height: MediaQuery.of(context).size.height*0.45,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textYourInfo(),
          _textEmail(),
          _textPassword(),
          _buttonLogin()
        ],
      ),
    ),
  );
}


Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 40,bottom: 45),
    child: Text("INGRESA ESTA INFORMACIÓN",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textEmail(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: loginController.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Correo electronico',
        prefixIcon: Icon(Icons.email)
      ),
     ),
   );
}

Widget _textPassword(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: loginController.passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: Icon(Icons.lock)
      ),
     ),
   );
}

Widget _buttonLogin(){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: ElevatedButton(
      onPressed: ()=>loginController.login(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("LOGIN",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}

}