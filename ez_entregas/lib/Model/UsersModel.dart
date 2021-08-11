import 'package:flutter/material.dart';

class UsersModel{

  // dados usuario
  TextEditingController cName = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPass = TextEditingController();
  TextEditingController cPassConf = TextEditingController();
  List<Map<String, dynamic>> listAddress = [];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome":this.cName.text,
      "email":this.cEmail.text,
      "pass":this.cPassConf.text,
      "listAddress":this.listAddress,
    };
    return map;
  }

}