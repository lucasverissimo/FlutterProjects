// tela com a lista de pedidos efetuados
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key key}) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Orders List"),
    );
  }
}
