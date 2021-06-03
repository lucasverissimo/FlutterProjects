import 'package:behind_lens/View/Screens/TabsHome/CompanyFollowingTab.dart';
import 'package:behind_lens/View/Screens/TabsHome/HomeTab.dart';
import 'package:behind_lens/View/Screens/TabsHome/OptionsTab.dart';
import 'package:behind_lens/View/Screens/TabsHome/PeopleFollowingTab.dart';
import 'package:flutter/material.dart';
import 'package:behind_lens/View/Common/AppBarCommon.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  TabController _controllerTabs;

  // Future inicializarFirebase() async {
   // await Firebase.initializeApp();

   // FirebaseFirestore db = FirebaseFirestore.instance;

   // db.collection("usuarios")
   //     .doc("002")
   //     .set({
   //   "nome":"Poliana Silva",
   //   "idade":"27",
   // });
    // adicionando dados, para atualizar basta manter o id (doc) e mudar os dados normalmente. Se retirar um indice, ele será retirado na atualização.

    /*
    db.collection("usuarios")
    .doc("002")
    .set({
      "nome":"Poliana Silva",
      "idade":"27",
    });
    */

    // Desta foram ele adiciona um id automático para o document (doc)
    /* DocumentReference ref = await db.collection("noticias")
    .add({
      "titulo":"Ondas de calor em São Paulo",
      "descricao":"Texto de exemplo"
    });*/

    //print("Item salvo: "+ref.id);

    // atualizando dados utilizando o id do doc
    /*
    db.collection("noticias")
        .doc("vLRxTSKVjGLq3ah4jJC8")
        .set({
      "titulo":"Ondas de calor em São Paulo - Alterado",
      "descricao":"Texto de exemplo"
    });
    */
  //}

  @override
  void initState() {
    super.initState();

    TabController tabs = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0
    );

    setState(() {
      _controllerTabs = tabs;
    });
  }
  @override
  Widget build(BuildContext context) {

    // inicializarFirebase();

    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: appBarCommon(
        context,
        bottomAppBar: TabBar(
            indicatorColor: Color(0xfffe386b),
            labelColor: Color(0xfffe386b),
            unselectedLabelColor: Color(0xff90d5e4),
            controller: _controllerTabs,
            tabs: [
              Tab(
                icon: Icon(Icons.article_outlined),
              ),
              Tab(
                icon: Icon(Icons.people_alt_outlined),
              ),
              /*Tab(
                icon: Icon(Icons.apartment_rounded),
              ),*/
              Tab(
                icon: Icon(Icons.menu_open_outlined),
              ),
            ]
        )
      ),
      body: Container(
        child: TabBarView(
            controller: _controllerTabs,
            children: [
              HomeTab(),
              PeopleFollowingTab(),
              //CompanyFollowingTab(),
              OptionsTab(),
            ]
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xfffe386b),
        child: Icon(Icons.camera_alt_outlined, size: 30, color: Color(0xffffffff),),
        elevation: 3,
        focusColor: Color(0xff555555),
        hoverColor: Color(0xff555555),
        heroTag: 'btnPost',
        onPressed: (){
          Navigator.pushNamed(context, "/addNewPost");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
