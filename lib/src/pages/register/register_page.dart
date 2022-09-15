import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/register/register_controller.dart';
import 'package:ios/src/utils/theme/style.dart';

class RegisterPage extends StatelessWidget {
  
  // //instanciamos el controlador Register
   RegisterController registerController = Get.put(RegisterController());
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _imageCover(context),
        _buttonBack()
      ],
      ),
    );
  }


  Widget _buttonBack(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: ()=>Get.back(), 
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios,
          size: 30,),
        ),
      ),
    );
  }

Widget _backgruoundCover(BuildContext context){
   return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height*0.4,
    color: miTemaPrincipal,
   );
}



Widget _imageCover(BuildContext context){
  return  SafeArea(
    child: Container(
      margin: EdgeInsets.only(top:30 ),
      alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: ()=>registerController.showAlertDialog(context),
          //control de estado setState se reemplaza por este GetBuilder<RegisterController>
          child: GetBuilder<RegisterController>(
            builder: (value)=>CircleAvatar(
            backgroundImage:
              registerController.imageFile!=null? FileImage(registerController.imageFile!)  :
              AssetImage('assets/img/profile.png') as ImageProvider,
              // as ImageProvider le hacemos un casteo
            radius: 85,
            backgroundColor: Colors.white,
            ),), 
        ),
        ),
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
    height: MediaQuery.of(context).size.height*0.60,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textYourInfo(),
          _textEmail(),
          _textName(),
          _textApellido(),
          _textTelefono(),
          _textPassword(),
          _textPasswordRep(),
          _buttonRegister(context)
        ],
      ),
    ),
  );
}


Widget _textYourInfo(){
  return Container(
    margin: EdgeInsets.only(top: 30,bottom: 30),
    child: Text("REGISTRATE",
    style: TextStyle(color: Colors.black,
     fontWeight: FontWeight.bold),));
}

Widget _textEmail(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Correo electronico',
        prefixIcon: Icon(Icons.email)
      ),
     ),
   );
}



Widget _textName(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.nameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Nombre',
        prefixIcon: Icon(Icons.person)
      ),
     ),
   );
}



Widget _textApellido(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.lastnameController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Apellido',
        prefixIcon: Icon(Icons.person)
      ),
     ),
   );
}

Widget _textTelefono(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Telefono',
        prefixIcon: Icon(Icons.phone)
      ),
     ),
   );
}





Widget _textPassword(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: Icon(Icons.lock)
      ),
     ),
   );
}



Widget _textPasswordRep(){
   return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
     child: TextField(
      controller: registerController.repitpasswordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Confirmar contraseña',
        prefixIcon: Icon(Icons.lock)
      ),
     ),
   );
}

Widget _buttonRegister(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: ElevatedButton(
      onPressed: ()=>registerController.register(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Registrarse",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}

}