import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:behind_lens/View/Common/LoadingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _errorLogin = "";
  bool _isLogged = true;


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

  _initLogin() async {
    String email = _controllerEmail.text;
    String pass = _controllerSenha.text;
    Users user = Users("", email);
    user.pass = pass;
    UserController userController = UserController();
    String r = await userController.login(user);
    if(r == "ok") {
      setState(() {
        _errorLogin = "Usuario autenticado!";
      });
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
    }else{
      setState(() {
        _errorLogin = r;
      });
    }

  }

  Future _checkUserLogin() async{
    UserController userController = UserController();
    bool r = await userController.checkIsLogged();
    if( r == true ){
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
    }else{
      setState(() {
        _isLogged = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _randonBackGround();
    _checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {

    double largImg = (MediaQuery.of(context).size.width / 100) * 75;

    var borderDefault = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.white,
          width: 2
      ),
    );

    if(_isLogged == true){
      return LoadingPage();
    }else {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/" + _background),
                fit: BoxFit.cover
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 60, top: 40),
                    child: Image.asset(
                      "assets/logo-invert.png", width: largImg,),
                  ),
                  /* Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Digite seu e-mail e senha para continuar.", style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),*/
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
                        hintText: "E-mail",
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
                        hintText: "Senha",
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
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _initLogin();
                      },
                      child: Text("Entrar", style: TextStyle(fontSize: 20),),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Colors.white,
                            width: 2
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text(
                      _errorLogin,
                      style: TextStyle(color: Colors.yellow, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Esqueci minha senha",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registerUser");
                      },
                      child: Text(
                        "Cadastre-se",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
