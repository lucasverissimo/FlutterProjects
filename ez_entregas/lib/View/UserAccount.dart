// Minha conta, com meus dados cadastrais (Nome, e-mail, CPF).

import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Components/DefaultInputTextField.dart';
import 'package:ez_entregas/Model/UsersModel.dart';


class UserAccoount extends StatefulWidget {

  String id;
  UserAccoount(this.id);
  @override
  _UserAccoountState createState() => _UserAccoountState();
}

class _UserAccoountState extends State<UserAccoount> {

  UsersModel _users = new UsersModel();

  _changeUser(UsersModel users, context){

  }

  _changePass(UsersModel users, context){

  }

  @override
  void initState() {
    super.initState();
    print("ID do usuario: "+widget.id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarDefault("Alterar Dados"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Alterar dados".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Color(0xff555555),
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "Preencha os campos que deseja alterar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            ),
            textField(_users.cName, "Nome:"),
            textField(_users.cEmail, "E-mail:", readOnly: true),
            textField(_users.cCpf, "CPF:", readOnly: true),
            submitButton(
              "Salvar alterações",
                  (){_changeUser(_users, context);},
              colorText: Color(0xfff76636),
              bgColor: Color(0xffffffff),
              colorBorder: Color(0xfff76636),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Alterar Senha".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xff555555),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "Preencha os dados para alterar senha",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            ),
            textField(_users.cPass, "Senha:"),
            textField(_users.cPassConf, "Confirmar senha:"),
            submitButton(
              "Alterar senha",
                  (){_changePass(_users, context);},
              colorText: Color(0xfff76636),
              bgColor: Color(0xffffffff),
              colorBorder: Color(0xfff76636),
            ),
          ],
        ),
      ),
    );

  }
}
