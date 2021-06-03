
import 'dart:async';
import 'dart:io';

import 'package:behind_lens/Model/Database/UploadDB.dart';
import 'package:behind_lens/Model/Database/UsersDB.dart';
import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserController{

  TaskSnapshot snapshot;

  String _validatorBasic(Users user){

    if(user.name.length < 3){
      return "Preencha o nome corretamente!";
    }else
    if(EmailValidator.validate(user.email) == false){
      return "Preencha o e-mail corretamente!";
    }else
    if(user.pass.length < 7){
      return "A senha deve possuir no minimo 8 digitos!";
    }else
    if(user.birthDate.length < 8){
      return "Selecione sua data de nascimento!";
    }else{
      return "ok";
    }

  }

  String _validatorUpdate(Users user){
    if(user.name.length < 3){
      return "Preencha o nome corretamente!";
    }else
    if(EmailValidator.validate(user.email) == false){
      return "Preencha o e-mail corretamente!";
    }else
    if(user.birthDate.length < 8){
      return "Selecione sua data de nascimento!";
    }else{
      return "ok";
    }
  }

  String _validatorLogin(Users user){
    if(EmailValidator.validate(user.email) == false){
      return "Preencha o e-mail corretamente!";
    }else
    if(user.pass.length < 7){
      return "Preencha a senha corretamente!";
    }else{
      return "ok";
    }
  }

  Future<String> registerUser(Users user) async {
    if(_validatorBasic(user) == "ok"){

      UsersDB db = UsersDB();
      String r = await db.registerUser(user);
      if(r == "ok") {

        return "Cadastrado com sucesso!";
      }else{

        return r;
      }
    }else{

      return _validatorBasic(user);
    }
  }

  Future<String> login(Users user) async {
    if(_validatorLogin(user) == "ok"){
      UsersDB db = UsersDB();
      String r = await db.login(user);
      if(r == "Usuario autenticado!"){
        return "ok";
      }else{
        return r;
      }
    }else{
      return _validatorLogin(user);
    }
  }

  Future<bool> checkIsLogged() async {
    UsersDB db = UsersDB();
    bool r = await db.isLogged();
    return r;
  }

  logout(){
    UsersDB db = UsersDB();
    db.logout();
  }

  static Future<Map<String, dynamic>> loadingInfoProfile({String id}) async {
    UsersDB db = UsersDB();
    return await db.loadingInfoProfileDB(id: id);
  }


  Future<String> updateUser(Users user) async {
    if(_validatorUpdate(user) == "ok"){

      UsersDB db = UsersDB();
      return await db.updateInfoUser(user);

    }else{
      return _validatorUpdate(user);
    }
  }

  Future<String> changeImageProfile(String user, File image) async {

    UploadDB upDb = UploadDB();
    await upDb.uploadStorage("profile", image, user, profile: true);
    Timer.periodic(new Duration(milliseconds: 200), (timer) {
      if(upDb.progressUpload == "Upload concluido!"){
        this.snapshot = upDb.snapshot;
        timer.cancel();
      }

    });
  }

  Future<String> changePassword(String pass) async {
    UsersDB db = UsersDB();
    String r = await db.changePassword(pass);
    return r;
  }

  Future<List> readingPosts(String doc, int qtd) async {
    if(doc == null || qtd < 1){
      return null;
    }else{
      UsersDB db = UsersDB();
      List r = await db.readingPostsProfile(doc, qtd);
      return r;
    }
  }

  Future<List> searchUsers(String name) async {
    UsersDB db = UsersDB();
    List r = await db.searchUsers(name);
    return r;
  }

}