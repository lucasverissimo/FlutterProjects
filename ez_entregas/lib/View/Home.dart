// tela inicial com menu lateral, navegação em abas e lista de produtos.
import 'dart:ui';

import 'package:ez_entregas/Components/AppBarDefault.dart';
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
  bool showDrawer = true;
  List<Map<String, dynamic>> _categorias = [
    {"nome": "Lanches", "id":"id"},
    {"nome": "Bebidas", "id":"id"},
    {"nome": "Combos", "id":"id"},
    {"nome": "Sobremesas", "id":"id"},
    {"nome": "Promoções", "id":"id"},
  ];

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: 0
    );
  }
  @override
  Widget build(BuildContext context) {

    double heightListView = MediaQuery.of(context).size.height;
    double heightHeaderListView = (MediaQuery.of(context).size.height / 100) * 20;
    double heightTitleMenu = (MediaQuery.of(context).size.height / 100) * 5;
    double heightListMenu = (MediaQuery.of(context).size.height / 100) * 70;
    double heightFooterMenu = (MediaQuery.of(context).size.height / 100) * 5;

    return Scaffold(
      appBar: appBarDefault("Ez Entregas Delivery!"),
      drawer: showDrawer == true ? Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          height: heightListView,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: heightHeaderListView,
                child:  DrawerHeader(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: Border.all(
                      color: Colors.transparent,
                      width: 0
                    )
                  ),
                  child: Center(
                    child: Image.asset("assets/images/logo.png", width: 200,),
                  ),
                ),
              ),
              Container(
                height: heightTitleMenu,
               /* decoration: BoxDecoration(
                  color: Color(0xfff0f0f0),
                ),*/
                child: Center(
                  child: Text(
                    "CATEGORIAS",
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                height: heightListMenu,
                decoration: BoxDecoration(
                  color: Color(0xffffffff)
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ListView(
                    children: _categorias.map((Map<String, dynamic> item) {

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Color(0xfff0f0f0),
                            ),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 20, 20, 20),
                              child: Text(
                                item['nome'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            onTap: () {
                              print(item);
                              Navigator.pushNamed(
                                  context, "/category", arguments: "idCategoria"
                              );
                            },
                          ),
                        ),
                      );

                      /*return ListTile(
                        title: Text(item['nome']),
                        onTap: (){
                          print(item);
                        },

                    );*/

                    },).toList(),
                  ),
                ),
              ),
              Container(
                height: heightFooterMenu,
                decoration: BoxDecoration(
                  color: Color(0xfff76636),
                ),
                child: Center(
                  child: Text("Desenvolvido por: Ez Entregas", style: TextStyle(fontSize: 12, color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ) : null,
      body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
           // OrdersList(),
            AccountMenu(),
          ]
      ),
      bottomNavigationBar: SafeArea(
          child: TabBar(
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
      ),
    );
  }
}
