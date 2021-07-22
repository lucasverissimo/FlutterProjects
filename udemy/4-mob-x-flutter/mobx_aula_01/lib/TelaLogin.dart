import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_aula_01/ControllersMobX/controllerbasetelalogin.dart';
import 'package:mobx_aula_01/ListasOberservaveis.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  TextEditingController _controllerEmail = TextEditingController(text: "lucas_verissimo@outlook.com");
  TextEditingController _controllerSenha = TextEditingController(text: "lucas123");

  void _editEmail(value){}
  void _editSenha(value){}

  ControllerTelaLogin? controller;
  ReactionDisposer? reactionDisposer;

  // PROVIDER: compartilha dados com as demais telas. É configurado na raiz da main.
  // OBS: Só funciona para recuperar dados dentro do didChangeDependecies e do build.
  // NÃO FUNCIONA DENTRO DO initState
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // monitora os itens do controller e notifica ao haver alteração em algum deles.
    //autorun((_){
      //print(controller.email);
      //print(controller.senha);
      // print(controller.formularioValidado);
    //});

    // reaction: monitora uma função, e ao haver mudanças ele retorna o valor que é retornado na função.
    // tem que adicionar um dispose para ele pois mesmo se navegar em outras telas este reaction ainda estará ativo.
    controller = Provider.of<ControllerTelaLogin>(context);
    reactionDisposer = reaction(
      (_) => controller!.usuarioLogado,
      (bool usuarioLogado){
      if(usuarioLogado){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ListasObservaveis())
        );
      }
    });
  }

  @override
  void dispose() {
    reactionDisposer!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela login"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _campoText("E-mail: ", _editEmail, _controllerEmail, controller!.setEmail),
            _campoText("Senha: ", _editSenha, _controllerSenha, controller!.setSenha),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Observer(
                builder: (_){
                  return Text(
                      controller!.formularioValidado ? "" : "* Campos não validados"
                  );
                },
              ),
            ),
            Observer(
              builder: (_){
                return ElevatedButton(
                    onPressed: controller!.formularioValidado ? (){
                      controller!.logar();
                    } : null,
                    child: controller!.carregando
                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),)
                        : Text("Logar")
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget _campoText(String lblText, Function changeFunc, TextEditingController controllerInput, Function controllerValue){
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: lblText
        ),
        onChanged: (value) => controllerValue(value),
        controller: controllerInput,
      ),
  );
}
