import 'package:mobx/mobx.dart';

class Controller {
  var _contador = Observable(0);
  Action incrementar;

  Controller(){
    incrementar = Action(_incrementar);
  }

  _incrementar(){
    contador++;
  }

  int get contador => _contador.value;

  set contador (int novoValor )=> _contador.value = novoValor;
}