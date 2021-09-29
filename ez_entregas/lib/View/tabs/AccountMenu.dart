// Lista de menus da conta do cliente, com opções de: Minha conta, meus pedidos, Endereços cadastrados.abstract
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Components/DefaultIconButton.dart';
import 'package:ez_entregas/View/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AccountMenu extends StatefulWidget {
  const AccountMenu({Key key}) : super(key: key);

  @override
  _AccountMenuState createState() => _AccountMenuState();
}

class _AccountMenuState extends State<AccountMenu> {

  bool _isLogged = false;
  String _userName = "Lucas Garcez";

  @override
  void initState() {
    super.initState();

    this._isLogged = true;
  }

  @override
  Widget build(BuildContext context) {

    if(_isLogged == false){
      return Login();
    }else{
      return SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Seja bem-vindo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _userName,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff000000)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            iconButton(
              "Meus Pedidos", (){
              Navigator.pushNamed(context, "/ordersList");
            },
              Icon(Icons.shopping_cart,
              color: Color(0xffcccccc),),
              colorText: Color(0xff000000),
              colorBorder:  Colors.transparent,
              widthBorder: 0,
              description: "Consulte seus ultimos pedidos"
            ),
            iconButton(
                "Dados", (){
                  Navigator.pushNamed(context, "/userAccount", arguments: "idUsuario");
            },
                Icon(Icons.account_circle,
                  color: Color(0xffcccccc),),
                colorText: Color(0xff000000),
                colorBorder:  Colors.transparent,
                widthBorder: 0,
                description: "Seus dados de cadastro"
            ),
            iconButton(
                "Endereços", (){
                  Navigator.pushNamed(context, "/addressList");
                },
                Icon(Icons.motorcycle_sharp,
                  color: Color(0xffcccccc),),
                colorText: Color(0xff000000),
                colorBorder:  Colors.transparent,
                widthBorder: 0,
                description: "Endereços para entrega"
            ),
            iconButton(
                "Sair", (){
                  setState(() {
                    _isLogged = false;
                  });
                },
                Icon(Icons.logout,
                  color: Color(0xfff76636),),
                colorText: Color(0xfff76636),
                colorBorder:  Colors.transparent,
                widthBorder: 0,
                description: "Sair de sua conta"
            )
          ],
        ),
      );
    }

  }




}
