import 'package:mobx/mobx.dart';
import 'package:mobx_aula_01/ControllersMobX/item_lista_controller.dart';
part 'controllerlistasobservaveis.g.dart';

class ControllerListasObservaveis = ControllerListasObservaveisBase with _$ControllerListasObservaveis;

abstract class ControllerListasObservaveisBase with Store{

  @observable
  String novoItem = "";

  @action
  void setNovoItem(String valor) => novoItem = valor;

  ObservableList<ItemListaController> listaItens = ObservableList<ItemListaController>();
  // verifica se houve mudanças nos itens desta lista.

  @action
  void adicionarItem(){
    listaItens.add(ItemListaController(novoItem));
  }

}