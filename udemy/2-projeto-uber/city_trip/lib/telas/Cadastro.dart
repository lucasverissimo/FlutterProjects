import 'package:city_trip/model/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();
  bool _isDriver = false;
  String _mensagemErro = "";

  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(nome.length < 3){
      setState(() {
        _mensagemErro = "Preencha o campo nome!";
      });
    }else
    if(email.isEmpty || !EmailValidator.validate(email)){
      setState(() {
        _mensagemErro = "Preencha o e-mail corretamente!";
      });
    }else
    if(senha.length < 8){
      setState(() {
        _mensagemErro = "A senha deve possuir ao menos 8 caracteres!";
      });
    }else{
      Usuario usuario = Usuario();
      usuario.nome = nome;
      usuario.email = email;
      usuario.senha = senha;
      usuario.tipoUsuario = usuario.verificaTipoUsuario(_isDriver);
      _cadastrarUsuario(usuario);
    }

  }

  _cadastrarUsuario(Usuario usuario) async {
      await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha)
      .then((UserCredential firebaseUser) async {

        FirebaseFirestore db = FirebaseFirestore.instance;

        await db.collection("usuarios")
        .doc(firebaseUser.user.uid)
        .set(usuario.toMap())
        .catchError((onError){
          print(onError);
        });

        switch(usuario.tipoUsuario){
          case "motorista":
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/painel-motorista",
                (_) => false
            );
            break;
          case "passageiro":
            Navigator.pushNamedAndRemoveUntil(
                context,
                "/painel-passageiro",
                (_) => false
            );
            break;
        }

      }).catchError((onError){
        print(onError);
      });
  }

  @override
  Widget build(BuildContext context) {

    double widthImg = (MediaQuery.of(context).size.width / 100) * 20;

    InputBorder borderDefault = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          width: 1,
          color: Color(0xffdddddd)
      ),
    );

    InputBorder borderFocus = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          width: 1,
          color: Color(0xffdddddd)
      ),
    );

    InputBorder borderDisabled = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          width: 1,
          color: Color(0xffdddddd)
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastre-se", style: TextStyle(color: Color(0xffe51b23)),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg-splash-screen.png"),
              fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    "assets/simple-logo.png",
                    width: widthImg,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Crie sua conta viage agora mesmo!", style: TextStyle(fontSize: 20, color: Color(0xff666666)),),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nome:",
                      hintText: "Preencha com nome...",
                      labelStyle: TextStyle(fontSize: 16, color: Color(0xff666666)),
                      border: borderDefault,
                      enabledBorder: borderDefault,
                      disabledBorder: borderDisabled,
                      focusedBorder: borderFocus,
                      filled: true,
                      fillColor: Color.fromRGBO(240, 240, 240, 0.8),
                    ),
                    controller: _controllerNome,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "E-mail:",
                      hintText: "Preencha com seu e-mail...",
                      labelStyle: TextStyle(fontSize: 16, color: Color(0xff666666)),
                      border: borderDefault,
                      enabledBorder: borderDefault,
                      disabledBorder: borderDisabled,
                      focusedBorder: borderFocus,
                      filled: true,
                      fillColor: Color.fromRGBO(240, 240, 240, 0.8),
                    ),
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Senha: ",
                      hintText: "Preencha com sua senha...",
                      labelStyle: TextStyle(fontSize: 16, color: Color(0xff666666)),
                      border: borderDefault,
                      enabledBorder: borderDefault,
                      disabledBorder: borderDisabled,
                      focusedBorder: borderFocus,
                      filled: true,
                      fillColor: Color.fromRGBO(240, 240, 240, 0.8),
                    ),
                    controller: _controllerSenha,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    obscuringCharacter: '*',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5,),
                  child: Text("Você é?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Sou um passageiro", style: TextStyle(fontSize: 14,),),
                        Switch(
                            value: _isDriver,
                            onChanged: (value){
                              setState(() {
                                _isDriver = value;
                              });
                            },
                          activeColor: Color(0xffe51b23),
                        ),
                        Text("Sou um motorista", style: TextStyle(fontSize: 14,),),
                      ],
                    )
                ),

                ElevatedButton(
                  onPressed: (){
                    _validarCampos();
                  },
                  child: Text("Cadastrar"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      primary: Color(0xffe51b23),
                      onPrimary: Colors.white
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(fontSize: 14, color: Colors.red),
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
