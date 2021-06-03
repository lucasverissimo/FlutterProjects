import 'package:city_trip/telas/Cadastro.dart';
import 'package:city_trip/telas/Corrida.dart';
import 'package:city_trip/telas/Home.dart';
import 'package:city_trip/telas/PainelMotorista.dart';
import 'package:city_trip/telas/PainelPassageiro.dart';
import 'package:flutter/material.dart';

class Rotas {

  static Route<dynamic> gerarRotas(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){
      case "/":
        return MaterialPageRoute( builder: (_) => Home() );
      break;
      case "/cadastro":
        return MaterialPageRoute( builder: (_) => Cadastro() );
      break;
      case "/painel-motorista":
        return MaterialPageRoute( builder: (_) => PainelMotorista() );
      break;
      case "/painel-passageiro":
        return MaterialPageRoute( builder: (_) => PainelPassageiro() );
      break;
      case "/corrida":
        return MaterialPageRoute( builder: (_) => Corrida(args) );
      break;
      default:
        _erroRota();
      break;
    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(

        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }

}