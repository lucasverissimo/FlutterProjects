import 'package:city_trip/model/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  TextEditingController _controllerEmail = TextEditingController(text: 'motorista@teste.com'); //lucas@teste.com
  TextEditingController _controllerSenha = TextEditingController(text: 'lucas123');
  String _mensagemErro = "";
  bool _isLoading = false;
  bool _isAuth = true;



  _login() async {


    var status = await Permission.location.isGranted;

    if(status == false){
      if(await Permission.location.isPermanentlyDenied == true){
        openAppSettings();
        return;
      }else{
        if(await Permission.location.request().isGranted == false){
          return;
        }
      }
    }

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isEmpty || !EmailValidator.validate(email)){
      setState(() {
        _mensagemErro = "Preencha o e-mail corretamente!";
      });
    }else
    if(senha.length < 8){
      setState(() {
        _mensagemErro = "Preencha a senha corretamente!";
      });
    }else{
      Usuario usuario = Usuario();
      usuario.email = email;
      usuario.senha = senha;

      FocusScope.of(context).requestFocus(FocusNode());
      _autenticar(usuario);
    }
  }

  _autenticar(Usuario usuario) async {
    setState(() {
      _isLoading = true;
    });
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.senha)
    .then((UserCredential firebaseUser){

      _redirecionaPainelPorTipoUsuario(firebaseUser.user.uid);


    }).catchError((onError){

      print(onError.toString());
      setState(() {
        _mensagemErro = "Usuário ou senha incorretos!";
        _isLoading = false;
      });
    });
  }
  
  _redirecionaPainelPorTipoUsuario(String idUsuario) async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db
        .collection("usuarios")
        .doc(idUsuario)
        .get();

    Map<String, dynamic> dados = snapshot.data();


    setState(() {
      _isLoading = false;
    });

    switch(dados['tipoUsuario']){
      case 'motorista':
        Navigator.pushReplacementNamed(context, "/painel-motorista");
        break;
      case 'passageiro':
        Navigator.pushReplacementNamed(context, "/painel-passageiro");
        break;
    }

  }

  _verificaUsuarioLogado() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    if( usuarioLogado != null ){
      _redirecionaPainelPorTipoUsuario(usuarioLogado.uid);
    }else{
      setState(() {
        _isAuth = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {

    double widthImg = (MediaQuery.of(context).size.width / 100) * 45;

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

    if(_isAuth){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg-splash-screen.png"),
                fit: BoxFit.cover
            ),
          ),
          child: Center(child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),),),
        ),
      );
    }else {
      return Scaffold(
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
                    padding: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "E-mail:",
                        hintText: "Preencha com seu e-mail...",
                        labelStyle: TextStyle(fontSize: 16, color: Color(
                            0xff666666)),
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
                        labelStyle: TextStyle(fontSize: 16, color: Color(
                            0xff666666)),
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

                  _isLoading == false
                      ? ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        textStyle: TextStyle(fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        primary: Color(0xffe51b23),
                        onPrimary: Colors.white
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(child: CircularProgressIndicator(
                      backgroundColor: Color(0xffe51b23),),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/cadastro");
                      },
                      child: Text(
                        "Não tem conta? Cadastre-se!",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
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
}
