import 'package:city_trip/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioFirebase{


  static Future<User> getUsuarioAtual() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {
    await Firebase.initializeApp();
    User firebaseUser = await getUsuarioAtual();
    String idUsuario = firebaseUser.uid;
    
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios").doc(idUsuario).get();
    Map<String, dynamic> dados = snapshot.data();
    String tipoUsuario = dados["tipoUsuario"];
    String nome = dados["nome"];
    String email = dados["email"];

    Usuario usuario = Usuario();
    usuario.idUsuario = idUsuario;
    usuario.tipoUsuario = tipoUsuario;
    usuario.nome = nome;
    usuario.email = email;

    return usuario;

  }

  static atualizarDadosLocalizacao(String idRequisicao, double lat, double long, String tipo) async{
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Usuario usuario = await getDadosUsuarioLogado();
    usuario.latitude = lat;
    usuario.longitude = long;
    db.collection("requisicoes")
    .doc(idRequisicao)
    .update({
      "${tipo}": usuario.toMap()
    });
  }

}