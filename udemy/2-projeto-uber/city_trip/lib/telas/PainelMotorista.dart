import 'dart:async';

import 'package:city_trip/telas/Corrida.dart';
import 'package:city_trip/util/StatusRequisicao.dart';
import 'package:city_trip/util/UsuarioFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  bool _loadingRequest = false;

  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  _deslogarUsuario() async {
    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaItemMenu(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configurações":
        print(itensMenu);
        break;
    }
  }

  Stream<QuerySnapshot> _adicionarListenerRequisicoes(){
    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;

    final stream = db.collection("requisicoes")
    .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
    .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });

  }

  _recuperarRequisicaoAtiva() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    User firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    
    // recuperando requisicao ativa (se existir).
    DocumentSnapshot document = await db.collection("requisicao_ativa_motorista")
    .doc(firebaseUser.uid)
    .get();
    Map<String, dynamic> dadosRequisicao = document.data();
    if(dadosRequisicao == null){
      _adicionarListenerRequisicoes();
      setState(() {
        _loadingRequest = true;
      });
      return;
    }else{
      Navigator.pushReplacementNamed(context, "/corrida", arguments: dadosRequisicao['id_requisicao']);
    }
  }

  @override
  void initState() {
    super.initState();
    // recuperar corridas ativas;
    _recuperarRequisicaoAtiva();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Painel motorista", style: TextStyle(color: Color(0xffe51b23)),),
        actions: [
          PopupMenuButton<String>(
              onSelected: _escolhaItemMenu,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              }
          ),
        ],
      ),
      drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xffe51b23), width: 5)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Image.asset("assets/logo.png", height: 120,),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Configurações', style: TextStyle(fontSize: 18),),
                    onTap: () => _escolhaItemMenu("Configurações"),
                    leading: Icon(Icons.settings, color: Color(0xffe51b23),),
                  ),
                  ExpansionTile(
                    title: Text("Categorias", style: TextStyle(fontSize: 18),),
                    leading: Icon(Icons.more_outlined, color: Color(0xffe51b23),),
                    children: [
                      ListTile(
                        title: Text("Opção 1", style: TextStyle(fontSize: 14),),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text("Opção 2", style: TextStyle(fontSize: 14),),
                        onTap: () {},
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Sair', style: TextStyle(fontSize: 18),),
                    onTap: () => _escolhaItemMenu("Deslogar"),
                    leading: Icon(Icons.logout, color: Color(0xffe51b23),),
                  ),
                ],
              ),
      ),
      body: _loadingRequest == false
      ? Center(child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),),)
      : StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),),);
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),),);
              break;
            case ConnectionState.active:
              if(snapshot.hasError){
                return Center(child: Text("Erro ao carregar dados!\nSaia e entre novamente de sua conta!", textAlign: TextAlign.center),);
              }else
              if(snapshot.data.docs.length == 0){
                return Center(child: Text("Suas solicitações de corrida irão aparecer aqui!\nAguardando solicitação de corrida...", textAlign: TextAlign.center,),);
              }else{
                QuerySnapshot querySnapshot = snapshot.data;
                return ListView.separated(
                    itemCount: querySnapshot.docs.length,
                    separatorBuilder: (context, index) => Divider(height: 2, color: Color(0xffdddddd),),
                    itemBuilder: (context, index){
                      List<DocumentSnapshot> requisicoes = querySnapshot.docs.toList();
                      DocumentSnapshot item = requisicoes[index];
                      Map<String, dynamic> dados = item.data();

                      return ListTile(
                        title: Text("Passageiro: " + dados["passageiro"]["nome"]),
                        subtitle: Text("Destino: "+ dados["destino"]["rua"]+", Nº: "+dados["destino"]["numero"]+", Bairro: "+dados["destino"]["bairro"]),
                        onTap: (){
                          Navigator.pushNamed(context, "/corrida", arguments: dados["id"]);
                        },
                      );
                    },
                );
              }
              break;
            case ConnectionState.done:
              return Center(child: Text("Conexao encerrada!"),);
              break;
          }

          return Container();
        },
      ),
    );
  }
}
