import 'package:mobx/mobx.dart';
import 'package:mobx_aula_01/controller.dart';
part 'controllerbasetelalogin.g.dart';

// para verificar mudanças constantes no arquivo, inserir comando abaixo
// flutter pub run build_runner watch
// NÃO FECHAR O TERMINAL

class ControllerTelaLogin = ControllerBaseTelaLogin with _$ControllerTelaLogin;

abstract class ControllerBaseTelaLogin with Store{


  ControllerBaseTelaLogin(){
    autorun((_){
     // print(email);
     // print(senha);
     // print(formularioValidado);
    });
  }

  @observable
  String email = '';

  @observable
  String senha = '';

  @observable
  bool usuarioLogado = false;

  @observable
  bool carregando = false;

  // ao combinar mais do que uma observable para checar mudanças, se cria um dado computado (computed).
  @computed
  String get emailSenha => "$email - $senha";

  @computed
  bool get formularioValidado => email.length >= 5 && senha.length >= 5;

  @action
  void setEmail(valor) => email = valor;

  @action
  void setSenha(valor) => senha = valor;

  @action
  Future<void> logar() async {

      carregando = true;

      // Processando
      await Future.delayed(Duration(seconds: 3));

      carregando = false;
      usuarioLogado = true;

  }

}