import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OptionsTab extends StatefulWidget {
  @override
  _OptionsTabState createState() => _OptionsTabState();
}

class _OptionsTabState extends State<OptionsTab> {

  _logout(){

    UserController userController = UserController();
    userController.logout();

    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Configurações",
              style: TextStyle(color: Colors.white, fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/profileConfig");
              },
              child: Text("Meus dados de perfil", style: TextStyle(fontSize: 18, color: Color(0xfffe386b)),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 20, bottom: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
              ),
            ),
          ),/*
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: (){},
              child: Text("Minhas empresas cadastradas", style: TextStyle(fontSize: 18, color: Color(0xfffe386b)),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 20, bottom: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
              ),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/accessConfig");
              },
              child: Text("Meus dados de acesso", style: TextStyle(fontSize: 18, color: Color(0xfffe386b)),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 20, bottom: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: (){
                _logout();
              },
              child: Text("Sair da minha conta", style: TextStyle(fontSize: 18, color: Color(0xfffe386b)),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 20, bottom: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
