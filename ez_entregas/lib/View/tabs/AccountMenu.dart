// Lista de menus da conta do cliente, com opções de: Minha conta, meus pedidos, Endereços cadastrados.abstract
import 'package:flutter/material.dart';

class AccountMenu extends StatefulWidget {
  const AccountMenu({Key key}) : super(key: key);

  @override
  _AccountMenuState createState() => _AccountMenuState();
}

class _AccountMenuState extends State<AccountMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Account Menu"),
    );
  }
}
