import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minhas_viagens/Mapa.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  _abrirMapa(String idViagem){

    Navigator.push(context,
      MaterialPageRoute(builder: (_) => Mapa(idViagem: idViagem,))
    );

  }

  _excluirViagem(String idViagem) async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('viagens')
    .doc(idViagem)
    .delete();
  }

  _adicionarLocal(){
    Navigator.push(
      context,        
      MaterialPageRoute(builder: (_) => Mapa())
    );
  }

  _adicionarListenerViagens() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    final stream = db.collection('viagens').snapshots();

    stream.listen((dados) {

      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();

    _adicionarListenerViagens();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Minhas viagens"),
        backgroundColor: Color(0xff0066cc),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot){
          print(snapshot.connectionState);
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Container();
              break;
            case ConnectionState.active:

              QuerySnapshot querySnapshot = snapshot.data;

              List<DocumentSnapshot> viagens = querySnapshot.docs.toList();

              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: viagens.length,
                          itemBuilder: (context, index){
                            // String titulo = _listaViagens[index];

                            DocumentSnapshot item = viagens[index];
                            String titulo = item['titulo'];
                            String idViagem = item.id;
                            return GestureDetector(
                              onTap: (){
                                _abrirMapa(idViagem);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(titulo),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          _excluirViagem(idViagem);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(Icons.remove_circle, color: Colors.red,),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      )
                  ),
                ],
              );
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
              break;
            case ConnectionState.done:
              return Container();
              break;
          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          _adicionarLocal();
        },
        backgroundColor: Color(0xff0066cc),
      ),
    );
  }
}
