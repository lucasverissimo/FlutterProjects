
class CategoryModel{

  String id;
  bool showHome;
  bool showMenu;
  String name;
  int order;
  String type;
  String productSelectionType;

  CategoryModel(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['nome'];
    this.showHome = map['exibirHome'];
    this.showMenu = map['exibirMenu'];
    this.order = map['ordem'];
    this.type = map['tipo'];
    this.productSelectionType = map['tipoSelecaoProduto'];
  }

}