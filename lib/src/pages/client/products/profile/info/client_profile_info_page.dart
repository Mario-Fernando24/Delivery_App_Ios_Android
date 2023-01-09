import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios/src/pages/client/products/profile/info/client_profile_info_controller.dart';
import 'package:ios/src/utils/theme/style.dart';


class ClientProfileInfoPage extends StatelessWidget {

   ClientProfileInfoController _clientProfileInfoController = Get.put(ClientProfileInfoController());

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(()=>  Stack(
        children: [
        _backgruoundCover(context),
        _boxForm(context),
        _imageCover(context),
         Column(
          children: [
        _buttonSingOut(context),
         _buttonRoles(context)
          ],
         )
      ],
      )),
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
          child: CircleAvatar(
            backgroundImage: _clientProfileInfoController.user.value.image!=null?
             NetworkImage(_clientProfileInfoController.user.value.image!):AssetImage('assets/img/profile.png') as ImageProvider,
            radius: 85,
          
            backgroundColor: Colors.white,
            ), 
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
    height: MediaQuery.of(context).size.height*0.40,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _textUserName(),
          _textEmail(),
          _textPhone(),
          _buttonUpdate(context)
        ],
      ),
    ),
  );
}


Widget _textUserName(){
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: ListTile(
        leading: Icon(Icons.person),
        title: Text("Nombre"),
        subtitle: Text('${_clientProfileInfoController.user.value.name ?? ''} ${_clientProfileInfoController.user.value.lastname ?? ''}'),
      ),
  );
}


Widget _textEmail(){
  return ListTile(
      leading: Icon(Icons.email),
      title: Text("Email"),
      subtitle: Text('${_clientProfileInfoController.user.value.email ?? ''}'),
    );
}

Widget _textPhone(){
  return  ListTile(
      leading: Icon(Icons.phone),
      title: Text("Telefono"),
      subtitle: Text('${_clientProfileInfoController.user.value.phone ?? ''}'),
    );
}





Widget _buttonUpdate(BuildContext context){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: ElevatedButton(
      onPressed: ()=>_clientProfileInfoController.goToUpdateProfile(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15)
      ),
       child: Text("Actualizar datos",
       style:TextStyle(
        color: Colors.black
       ),),
       ),
  );
}



  Widget _buttonSingOut(BuildContext context){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: ()=>_clientProfileInfoController.showAlertDialog(context), 
          color: Colors.white,
          icon: Icon(Icons.power_settings_new,
          size: 30,),
        ),
      ),
    );
  }


  Widget _buttonRoles(BuildContext context){
    return Container(
      margin: EdgeInsets.only(right: 20),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: ()=>_clientProfileInfoController.goToRoles(), 
        color: Colors.white,
        icon: Icon(Icons.supervised_user_circle,
        size: 30,),
      ),
    );
  }

}