import 'package:flutter/material.dart';
import 'package:mobx_aula_01/ControllersMobX/controllerbasetelalogin.dart';
import 'package:mobx_aula_01/TelaLogin.dart';
import 'package:provider/provider.dart';
import 'Contador.dart';
import 'ListasOberservaveis.dart';

void main(){
  runApp(MultiProvider(
    providers: [
      Provider<ControllerTelaLogin>(
        create: (_) => ControllerTelaLogin(),
      )
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Contador(),
      home: TelaLogin(),
    ),
  ));
}