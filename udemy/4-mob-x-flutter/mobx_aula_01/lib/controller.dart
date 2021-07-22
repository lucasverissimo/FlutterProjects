import 'package:mobx/mobx.dart';
part 'controller.g.dart';



class Controller = ControllerBase with _$Controller;

// mixin store é usado para geração de códigos automaticos
// comando para criar o arquivo com codigo automatico (colocar no terminal):
// flutter pub run build_runner build
abstract class ControllerBase with Store {

  ControllerBase(){
    // executa sempre que um observavel tem seu estado alterado.
    //autorun((_){
    //  print(contador);
    //});

  }

  @observable
  int contador = 0;

  @action
  incrementar(){
    contador++;
  }

  //var _contador = Observable(0);
  //Action incrementar;

  //Controller(){
  //  incrementar = Action(_incrementar);
  //}

  //_incrementar(){
  //  contador++;
  //}

  //int get contador => _contador.value;

  //set contador (int novoValor )=> _contador.value = novoValor;

}
