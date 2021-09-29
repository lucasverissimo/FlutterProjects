import 'package:ez_entregas/Model/AddressModel.dart';
import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Components/DefaultInputTextField.dart';
import 'package:ez_entregas/Model/UsersModel.dart';

class UserRegister extends StatefulWidget {
  bool isBuy;
  UserRegister({this.isBuy = false});

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {

  UsersModel _users = new UsersModel();
  AddressModel _address = new AddressModel();


  _cadastrar(UsersModel users, AddressModel address, BuildContext context){
    users.listAddress.add(address.toMap());
    users.listAddress.add(address.toMap());
    print(users.toMap());
    print(address.toMap());
  }

  @override
  void initState() {
    super.initState();
    print(widget.isBuy);
  }

  @override
  Widget build(BuildContext context) {

    // _users.cName.text = "Lucas Garcez Jorge";

    return Scaffold(
      appBar: appBarDefault("Cadastrar usuário"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Cadastrar".toUpperCase(),
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
                "Preencha os campos abaixo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            ),
            textField(_users.cName, "Nome:"),
            textField(_users.cEmail, "E-mail:"),
            textField(_users.cCpf, "CPF:"),
            textField(_users.cPass, "Senha:"),
            textField(_users.cPassConf, "Confirmar senha:"),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Endereço".toUpperCase(),
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
                "Dados para entrega de pedidos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 4,
                  child: textField(_address.cCep, "CEP:", keyboardType: TextInputType.number),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: textField(_address.cNum, "Número:"),
                ),
              ],
            ),
            textField(_address.cStreet, "Rua:", readOnly: true),
            textField(_address.cNeigh, "Bairro:", readOnly: true),
            textField(_address.cCity, "Cidade:", readOnly: true),
            textField(_address.cComp, "Complemento:"),
            submitButton(
                "Cadastrar",
                (){_cadastrar(_users, _address, context);},
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
