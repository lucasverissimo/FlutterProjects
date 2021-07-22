import 'package:mobx/mobx.dart';
part 'item_lista_controller.g.dart';

class ItemListaController = ItemListaControllerBase with _$ItemListaController;

abstract class ItemListaControllerBase with Store{

  ItemListaControllerBase(this.titulo);

  final String titulo;

  @observable
  bool marcado = false;

  @action
  void alterarMarcado(bool valor) => marcado = valor;

}