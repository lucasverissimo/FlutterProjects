import 'dart:math';

import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:behind_lens/Controller/User/UserController.dart';


class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  String _errorRegister = "";

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerDataNasc = TextEditingController();


  String _background = "";
  _randonBackGround(){
    int n = Random().nextInt(2);
    String bg = "";
    if(n == 0){
      bg = "bg-login-01.jpg";
    }else{
      bg = "bg-login-02.jpg";
    }

    setState(() {
      _background = bg;
    });

  }

  _initRegister() async {
    String name = _controllerNome.text;
    String email = _controllerEmail.text;
    String pass = _controllerSenha.text;
    String birthDate = _controllerDataNasc.text;

    Users user = Users(name.toLowerCase(), email);
    user.pass = pass;
    user.birthDate = birthDate;

    UserController userController = UserController();

    String r = await userController.registerUser(user);

    setState(() {
      _errorRegister = r;
      _controllerNome.text = "";
      _controllerEmail.text = "";
      _controllerSenha.text = "";
      _controllerDataNasc.text = "";
    });
    if(r == "Cadastrado com sucesso!") {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _randonBackGround();
  }

  @override
  Widget build(BuildContext context) {

    double largImg = (MediaQuery.of(context).size.width / 100) * 35;

    var borderDefault = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.white,
          width: 2
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Usuário"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/"+_background),
              fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
               Padding(
                  padding: EdgeInsets.only(bottom:30, top: 40),
                  child: Image.asset("assets/logo-invert.png", width: largImg,),
                ),
                 Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Preencha os campos abaixo para realizar seu cadastro", style: TextStyle(color: Colors.white, fontSize: 16,), textAlign: TextAlign.center,),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _controllerNome,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      hintText: "Nome:",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: borderDefault,
                      focusedBorder: borderDefault,
                      border: borderDefault,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      hintText: "E-mail:",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: borderDefault,
                      focusedBorder: borderDefault,
                      border: borderDefault,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _controllerSenha,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      hintText: "Senha:",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: borderDefault,
                      focusedBorder: borderDefault,
                      border: borderDefault,

                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String datatime = DateTime.now().toString();
                    List arrDatatime = datatime.split(" ");
                    List arrData = arrDatatime[0].split('-');
                    int year = int.parse(arrData[0]);
                    int lastData = year - 17;

                    int initialYear, month, day;
                    if(_controllerDataNasc.text.isEmpty) {
                      initialYear = year - 17;
                      month = 1;
                      day = 1;
                    }else{
                      String dataField = _controllerDataNasc.text;
                      List arrDataField = dataField.split("/");
                      initialYear = int.parse(arrDataField[2]);
                      month = int.parse(arrDataField[1]);
                      day = int.parse(arrDataField[0]);
                    }

                    final dataSelecionada = await showDatePicker(
                      context: context,
                      initialDate: DateTime(initialYear, month, day),
                      firstDate: DateTime(1959),
                      lastDate: DateTime(lastData, 12, 31),
                      builder: (_, child){
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      }
                    );

                    if(dataSelecionada != null) {
                      setState(() {
                        _controllerDataNasc.text = DateFormat('dd/MM/yyyy')
                            .format(dataSelecionada)
                            .toString();
                      });
                    }

                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      controller: _controllerDataNasc,
                      enabled: false,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Data de nascimento: ",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: borderDefault,
                        focusedBorder: borderDefault,
                        disabledBorder: borderDefault,
                        border: borderDefault,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: (){
                      _initRegister();
                    },
                    child: Text("Cadastrar", style: TextStyle(fontSize: 20),),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        color: Colors.white,
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Colors.white,
                            width: 2
                        ),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorRegister,
                    style: TextStyle(color: Colors.yellow, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: (){},
                    child: Text(
                      "Ao clicar em Cadastrar, você concorda com nossos Termos de Uso Política de Dados. Você poderá receber notificações por e-mail e cancelar isso quando quiser.",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: (){},
                        child: Text(
                          "Termos de Uso",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: GestureDetector(
                        child: Text(
                          "|",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: (){},
                        child: Text(
                          "Política de Dados",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

      ),
    );
  }

}
