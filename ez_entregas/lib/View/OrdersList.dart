// tela com a lista de pedidos efetuados
import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {

  List<Map<String, dynamic>> _ordersList = [];

  @override
  void initState() {
    super.initState();

    List<Map<String, dynamic>> orders = [];
    for(int i = 0; i < 10; i++){
      orders.add({
        'id':'00001',
        'numero':i.toString(),
        'data':'17/08/2021',
        'total':'R\$ 34,90'
      });
    }

    setState(() {
      _ordersList = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault("Lista de pedidos"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Sua lista de",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Pedidos",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff000000)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _ordersList.length,
                itemBuilder: (context, index){
                  Map<String, dynamic> order = _ordersList[index];
                  return ListTile(
                    title: Text('Pedido: '+ order['numero'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Data: '+order['data']+'\nTotal: '+order['total'], style: TextStyle(color: Color(0xff888888)),),
                    ),
                    horizontalTitleGap: 0,
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("#", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                    ),
                    contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                    onTap: (){},
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
