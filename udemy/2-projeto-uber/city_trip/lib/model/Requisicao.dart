import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Destino.dart';
import 'Usuario.dart';

class Requisicao{
  String _id;
  String _status;
  Usuario _passageiro;
  Usuario _motorista;
  Destino _destino;
  Future _awaitGetIdRequisicao;

  Requisicao(){
    _awaitGetIdRequisicao = _getIdRequisicao();
  }

  Future _getIdRequisicao() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference ref = db.collection("requisicoes").doc();
    this.id = ref.id;
  }

  Future get initGetIdRequisicao => _awaitGetIdRequisicao;

  Map<String, dynamic> toMap(){

    Map<String, dynamic> mapPassageiro = {
      "nome": this.passageiro.nome,
      "email": this.passageiro.email,
      "tipoUsuario": this.passageiro.tipoUsuario,
      "idUsuario": this.passageiro.idUsuario,
      "latitude": this.passageiro.latitude,
      "longitude": this.passageiro.longitude,
    };

    Map<String, dynamic> mapDestino = {
      "rua": this.destino.rua,
      "numero": this.destino.numero,
      "bairro": this.destino.bairro,
      "cep": this.destino.cep,
      "latitude": this.destino.latitude,
      "longitude": this.destino.longitude,
    };

    Map<String, dynamic> map = {};

    if(this._status != null){
      map['status'] = this._status;
    }

    map['id'] = this._id;
    map['passageiro'] = mapPassageiro;
    map['motorista'] = null;
    map['destino'] = mapDestino;

    return map;
  }

  Destino get destino => _destino;

  set destino(Destino value) {
    _destino = value;
  }

  Usuario get motorista => _motorista;

  set motorista(Usuario value) {
    _motorista = value;
  }

  Usuario get passageiro => _passageiro;

  set passageiro(Usuario value) {
    _passageiro = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}