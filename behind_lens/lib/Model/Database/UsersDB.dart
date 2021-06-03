import 'dart:async';
import 'package:behind_lens/Model/Database/Crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:behind_lens/Model/Entities/Users.dart';

class UsersDB {

  String _returnRegisterUser = "";
  String _returnLogin = "";
  String _returnUpdateInfo = "";
  FirebaseAuth _auth;

  _initUsersDB() async {
    await Firebase.initializeApp();
    this._auth = FirebaseAuth.instance;
  }

  Future<String> registerUser(Users u) async {
    await _initUsersDB();
    await this._auth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.pass
    ).then((firebaseUser) async {
      UserCredential userCredential = firebaseUser;
      Crud crud = Crud();
      Map<String, dynamic> dataUser = {
        "name": u.name,
        "email": u.email,
        "pass": u.pass,
        "birthDate": u.birthDate,
      };
      await crud.insertSimpleCollection(
          "users",
          userCredential.user.uid,
          dataUser
      );

      this._returnRegisterUser = "ok";

    }).catchError((error){

      this._returnRegisterUser =  "Erro ao cadastrar - Erro:"+error.toString();

    });
    return this._returnRegisterUser;
  }

  Future<String> login(Users user) async{
    await _initUsersDB();
    await this._auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.pass
    ).then((firebaseUser){
      this._returnLogin = "Usuario autenticado!";
    }).catchError((onError){
      this._returnLogin = "E-mail ou senha incorretos!";
    });
    return this._returnLogin;
  }

  Future<bool> isLogged() async {
    await _initUsersDB();
    User user = this._auth.currentUser;
    if(user != null){
      return true;
    }else{
      return false;
    }
  }

  Future<Map<String, dynamic>> loadingInfoProfileDB({String id}) async {
    await _initUsersDB();
    String uid;
    if(id == null) {
      User user = this._auth.currentUser;
      uid = user.uid;
    }else{
      uid = id;
    }

    if(uid != null) {
      Crud crud = Crud();
      Map<String, dynamic> map = await crud.readingCollection('users', document: uid);
      return map;
    }else{
      return null;
    }
  }

  Future<String> updateInfoUser(Users users) async {
    await _initUsersDB();
    User user = this._auth.currentUser;
    await this._auth.currentUser.updateEmail(users.email).then((firebaseUser) async {

      Crud crud = Crud();
      await crud.updateSimpleCollection('users', user.uid, users.toMap());
      this._returnUpdateInfo = "informações atualizadas!";

    }).catchError((onError){
      this._returnUpdateInfo = "Erro ao atualizar - Erro: "+onError.toString();
    });

    return this._returnUpdateInfo;

  }

  logout() async {
    await _initUsersDB();
    this._auth.signOut();
  }

  Future<String> changePassword(String pass) async {
    await _initUsersDB();
    User user = this._auth.currentUser;
    await this._auth.currentUser.updatePassword(pass).then((firebaseUser) async {
      Crud crud = Crud();
      await crud.updateSimpleCollection('users', user.uid, {'pass':[pass]});
      this._returnUpdateInfo = "Senha atualizada com sucesso!";
    }).catchError((onError){
      this._returnUpdateInfo = "Erro ao atualizar senha!\nPor favor tente mais tarde\nErro: "+onError.toString();
    });

    return this._returnUpdateInfo;
  }

  Future<List> readingPostsProfile(String doc, int qtd) async {
    await _initUsersDB();
    Crud crud = Crud();
    List r = await crud.readingCollection('users', compostCollection: true, compostCollectionName: 'posts', document: doc, limit: qtd);
    return r;
  }

  Future<List> searchUsers(String name) async {
    await _initUsersDB();
    Crud crud = Crud();
    List r = await crud.searchDb('users', name);
    return r;
  }

}