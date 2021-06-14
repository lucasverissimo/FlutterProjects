import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_aula_01/controller.dart';

class Contador extends StatefulWidget {
  @override
  _ContadorState createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
/*
  int _contador = 0;

  _incrementar(){
    setState(() {
      _contador++;
    });
  }
*/

  Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contador"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Observer(
                builder: (_){
                  return Text(controller.contador.toString(), style: TextStyle(color: Colors.black, fontSize: 25),);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text("Incrementar", style: TextStyle(color: Colors.white),),
                onPressed: () => controller.incrementar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
