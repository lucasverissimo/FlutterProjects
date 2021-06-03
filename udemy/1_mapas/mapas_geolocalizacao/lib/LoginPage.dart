import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          _text("Login", "Digite o login", controller: _tLogin),
          SizedBox(
            height: 10,
          ),
          _text("Senha", "Digite sua Senha", password: true),
          SizedBox(
            height: 20,
          ),
          _button("Login",)
        ],
      ),
    );
  }
  _text(String label, String hint, {bool password = false, TextEditingController controller }) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      style: TextStyle(
        fontSize: 25,
        color: Colors.blue,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}

_button(String text) {
  return Container(
    height: 46,
    child: RaisedButton(
      color: Colors.blue,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      onPressed: () {},
    ),
  );
}
