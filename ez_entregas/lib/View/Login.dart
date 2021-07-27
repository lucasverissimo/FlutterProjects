// tela de autenticação. Ter componente reaproveitavel para logar tanto em um botão específico quanto antes de confirmar um pedido.
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Components/DefaultInputTextField.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPass = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double widthLogo = (MediaQuery.of(context).size.width / 100) * 60;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Container(
                width: widthLogo,
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            Text(
              'Acesse sua conta!',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
            ),
            textField(_textEmail, 'E-mail:'),
            textField(_textPass, 'Senha:', isPassword: true),
            submitButton("Cadastrar", (){ print("Clicou em cadastrar");}, colorBorder: Color(0xfff76636), colorText: Color(0xfff76636)),
            GestureDetector(
              onTap: (){ print("Criar conta");},
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: Text(
                  "Não possui conta?\nClique aqui e crie uma agora!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: (){ print("Esqueci minha senha");},
              child: Padding(
                padding: EdgeInsets.only(top:10, bottom: 15),
                child: Text(
                  "Esqueci minha senha!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
