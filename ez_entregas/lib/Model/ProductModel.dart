
class ProductModel{

  String id;
  String name;
  String category;
  List compCategory;
  int discount;
  String description;
  bool showProduct;
  String image;
  bool hasStock;
  int qtdStock;
  String price;

  ProductModel(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['nome'];
    this.category = map['categoria'];
    this.compCategory = map['categoriasComplementar'];
    this.discount = map['desconto'];
    this.description = map['descricao'];
    this.showProduct = map['exibirProduto'];
    this.image = map['imagem'];
    this.hasStock = map['possuiEstoque'];
    this.qtdStock = map['qtdEstoque'];
    this.price = map['preco'];
  }


  String finalProductPrice(){
    double price = double.parse(this.price);
    String newPrice;
    if(this.discount > 0){
      double priceDiscount = (price / 100) * this.discount;
      newPrice = 'R\$ '+(price - priceDiscount).toStringAsFixed(2);
    }else{
      newPrice = 'R\$ '+price.toStringAsFixed(2);
    }

    return newPrice;
  }

}