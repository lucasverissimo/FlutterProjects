// tela inicial com menu lateral, navegação em abas e lista de produtos.
import 'package:ez_entregas/View/tabs/AccountMenu.dart';
import 'package:ez_entregas/View/tabs/HomeScreen.dart';
import 'package:ez_entregas/View/OrdersList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: 1
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ez Entregas Delivery!", style: TextStyle(color: Color(0xfff76636)),),
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: (){}
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("teste"),
            ),
            ListTile(
              title: Text("Opção Menu"),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
           // OrdersList(),
            AccountMenu(),
          ]
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Color(0xfff76636),
        unselectedLabelColor: Color(0xffdddddd),
        /*indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xfff76636), width: 1.0),
          insets: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 48.0),
        ),*/
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        tabs: [
          Tab(icon: Icon(Icons.home_outlined,),),
      //    Tab(icon: Icon(Icons.list),),
          Tab(icon: Icon(Icons.account_circle_outlined),)
        ]
      ),
    );
  }
}
