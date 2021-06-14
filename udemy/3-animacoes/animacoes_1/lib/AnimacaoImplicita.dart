import 'package:flutter/material.dart';

class AnimacaoImplicita extends StatefulWidget {
  @override
  _AnimacaoImplicitaState createState() => _AnimacaoImplicitaState();
}

class _AnimacaoImplicitaState extends State<AnimacaoImplicita> {

  bool _status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animação implicita"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              padding: EdgeInsets.all(20),
              width: _status ? 200 : 300,
              height: _status ? 200 : 300,
              color: _status ? Colors.purpleAccent : Colors.black,
              child: Image.asset("imagens/logo.png"),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInBack,
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _status = !_status;
                  });
                },
                child: Text("Alterar"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
