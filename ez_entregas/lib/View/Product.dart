// tela de produto, com todas as opções normais de produto.
import 'dart:async';

import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Model/ProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Product extends StatefulWidget {
  ProductModel product;
  Product(this.product);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  ProductModel _product;

  int _qtd = 1;
  String _messageErrorQtd = "";
  bool _canBuy = false;
  bool _showBuyText = true;
  bool _hasRadio = false;
  int _qtdRadio = 0;
  int _maxItems = 0;
  String _precoPromocional = "";
  String _precoProduto = "";

  List<Map<String, dynamic>> _radioProducts = [
    {
      "id": "1",
      "nome": "Ao ponto",
      "preco": "0.00",
      "descricao": "",
      "exibirProduto": true,
      "categoria": "catcomp1"
    },
    {
      "id": "2",
      "nome": "Bem passado",
      "preco": "0.00",
      "descricao": "",
      "exibirProduto": true,
      "categoria": "catcomp1"
    },
    {
      "id": "3",
      "nome": "Bem passado + molho extra",
      "preco": "4.29",
      "descricao": "Molho barbecue",
      "exibirProduto": true,
      "categoria": "catcomp1"
    },
  ];

  List<Map<String, dynamic>> _checkboxProducts = [
    {
      "id": "1",
      "nome": "Alface",
      "preco": "2.00",
      "descricao": "",
      "exibirProduto": true,
      "categoria": "catcomp2"
    },
    {
      "id": "2",
      "nome": "Tomate",
      "preco": "2.00",
      "descricao": "",
      "exibirProduto": true,
      "categoria": "catcomp2"
    },
    {
      "id": "3",
      "nome": "Hamburguer extra",
      "preco": "7.29",
      "descricao": "Hamburguer 200g",
      "exibirProduto": true,
      "categoria": "catcomp2"
    },
    {
      "id": "4",
      "nome": "Cheddar",
      "preco": "3.59",
      "descricao": "Duas fatias",
      "exibirProduto": false,
      "categoria": "catcomp2"
    },
  ];

  List _productsComp = [];
  List _validationGroup = [];

  List<Map<String, dynamic>> _comCategories = [
    {
      "id": "catcomp1",
      "nome": "Ponto da carne",
      "tipoSelecao": "radio",
      "ordem": 0
    },
    {
      "id": "catcomp3",
      "nome": "Ponto da carne",
      "tipoSelecao": "radio",
      "ordem": 0
    },
    {
      "id": "catcomp2",
      "nome": "Adicionais",
      "tipoSelecao": "checkbox",
      "ordem": 1,
      "maximo": 2,
      "exibirQuantidade": true
    }
  ];

  _lessQtd() {
    if (_qtd > 1) {
      setState(() {
        _qtd = _qtd - 1;
        _messageErrorQtd = "";
      });

    }
    _calcPrice();
  }

  _moreQtd() {
    if (_product.hasStock) {
      if (_qtd <= _product.qtdStock) {
        int newQtd = _qtd + 1;
        if (newQtd > _product.qtdStock) {
          setState(() {
            _messageErrorQtd =
                "Total no estoque: " + _product.qtdStock.toString();
          });
        } else {
          setState(() {
            _qtd = newQtd;
          });
        }
      } else {
        setState(() {
          _messageErrorQtd =
              "Total no estoque: " + _product.qtdStock.toString();
        });
      }
    } else {
      setState(() {
        _qtd = _qtd + 1;
      });
    }

    _calcPrice();
  }

  void validateGroup(String value, String type, String groupName, {qtd = 1, String price = '0.00', bool qtdIncrement = true}) {
    for (int i = 0; i < _validationGroup.length; i++) {
      if (_validationGroup[i]["groupName"] == groupName) {
        if (type == "radio") {

          _validationGroup[i]["groupValue"] = value;

          if(_validationGroup[i]["groupPrice"] != null){

            if(_validationGroup[i]["groupPrice"] == '0.00'){

              if(price != '0.00'){
                _validationGroup[i]["groupPrice"] = price;
              }
            }else{
              if(price != '0.00'){

              }else{
                _validationGroup[i]["groupPrice"] = price;
              }
            }

          }else{

            if(price != '0.00'){
              _validationGroup[i]["groupPrice"] = price;
            }else{
              _validationGroup[i]["groupPrice"] = '0.00';
            }

          }

        } else {

          if(type == "checkbox") {

            List gp = _validationGroup[i]["groupValue"];
            bool findValue = false;
            for (int c = 0; c < gp.length; c++) {
              if (gp[c]["id"] == value) {

                if(qtd == 0) {
                  gp.removeAt(c);
                }else{
                  gp[c]["qtd"] = qtd;
                }

                findValue = true;
                break;
              }
            }

            if (findValue == false) {
              gp.add({"id": value, "qtd": qtd, 'price':price});
              _validationGroup[i]["groupValue"] = gp;
            } else {
              _validationGroup[i]["groupValue"] = gp;
            }


          }

        }

        setState(() {
          _validationGroup = _validationGroup;
        });

        _calcPrice();
        break;
      }
    }
  }

  void _calcPrice(){

    double newPrice = 0.0;
    for(int i = 0; i < _validationGroup.length; i++){
      Map<String, dynamic> group = _validationGroup[i];
      // print(group);
      if(group["groupType"] == "radio"){
        if(group["groupPrice"] != null) {
          if(group["groupPrice"] != "0.00") {
            newPrice = newPrice + (_qtd * double.parse(group["groupPrice"]));
          }
        }
      }else{
        if(group["groupValue"].length > 0){
          for(int c = 0; c < group["groupValue"].length; c++){
            Map<String, dynamic> item = group["groupValue"][c];
            double priceItem = item["qtd"] * double.parse(item['price']);
            newPrice = newPrice + (_qtd * priceItem);
          }
        }
      }

    }

    print(newPrice);
    if(widget.product.discount > 0){
      double priceDiscount = (double.parse(widget.product.price) / 100) * widget.product.discount;
      double pricePromo = double.parse(widget.product.price) - priceDiscount;
      newPrice = (pricePromo * _qtd) + newPrice;
    }else {
      newPrice = (double.parse(widget.product.price) * _qtd) + newPrice;
    }


    setState(() {
      _precoProduto = newPrice.toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    _product = widget.product;

    if (_product.hasStock) {
      if (_product.qtdStock == 0) {
        setState(() {
          _messageErrorQtd = "Produto esgotado!";
        });
      } else {
        if (_product.showProduct) {
          setState(() {
            _canBuy = true;
          });
        } else {
          setState(() {
            _showBuyText = false;
          });
        }
      }
    } else {
      if (_product.showProduct) {
        setState(() {
          _canBuy = true;
        });
      } else {
        setState(() {
          _showBuyText = false;
        });
      }
    }

    for (int i = 0; i < _comCategories.length; i++) {
      Map<String, dynamic> itemCategory = _comCategories[i];

      Map<String, dynamic> validation = new Map();
      if (_comCategories[i]["tipoSelecao"] == "radio") {
        itemCategory["products"] = _radioProducts;

        validation["groupName"] = _comCategories[i]["id"];
        validation["groupType"] = "radio";
        validation["groupValue"] = null;
      } else {
        itemCategory["products"] = _checkboxProducts;
        validation["groupName"] = _comCategories[i]["id"];
        validation["groupType"] = "checkbox";
        validation["groupValue"] = [];
      }

      setState(() {
        if (_comCategories[i]["tipoSelecao"] == "radio") {
          _hasRadio = true;
          _qtdRadio = _qtdRadio + 1;
        }

        _productsComp.add(itemCategory);
        _validationGroup.add(validation);
      });
    }

    if(_product.discount > 0){
      setState(() {
        _precoPromocional = _product.price;
        _precoProduto = _product.finalProductPrice();
      });
    }else{
      setState(() {
        _precoProduto = _product.price;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault("Produto"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Color(0xffeeeeee),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: Icon(
                      Icons.home,
                      color: Color(0xff888888),
                      size: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "/",
                      style: TextStyle(fontSize: 16, color: Color(0xff888888)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Nome da categoria",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff888888),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              _product.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Color(0xff555555),
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                _product.description,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff666666)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 20,
            ),
            ListView.builder(
              itemCount: _productsComp.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // print(_comCategories[index]["nome"]);

                Map<String, dynamic> c = _comCategories[index];
               // print(c);
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  decoration: BoxDecoration(
                    color: Color(0xffefefef),
                  ),
                  child: Column(
                    children: [
                      index > 0
                          ? SizedBox(
                              width: double.infinity,
                              height: 20,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          c["nome"].toString().toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      c["maximo"] != null && c["maximo"] > 0 ?
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Selecione ${_maxItems} de ${c["maximo"]} itens no máximo.",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ) : Container(),

                      c["tipoSelecao"] == "radio" ?
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Selecione ao menos uma opção abaixo!",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ) : Container(),
                      ListView.builder(
                        itemCount: c["products"].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index2) {

                          Map<String, dynamic> p = c["products"][index2];

                          String nomeP = p["nome"];

                          List<Widget> descriptionProduct = [
                            Text(nomeP,style: TextStyle(fontSize: 16),),
                            p["preco"] != "0.00" ? Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("R\$ "+p["preco"].replaceAll('.', ','),style: TextStyle(fontSize: 16),),
                            ) : Container(),
                            p["descricao"] != "" ? Text(p["descricao"],style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),) : Container(),
                          ];

                          if (_validationGroup[index]["groupName"] == c["id"]) {
                            if (c["tipoSelecao"] == "radio") {
                              return RadioListTile(
                                  contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                                  activeColor: Color(0xfff76636),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: descriptionProduct,
                                  ),
                                  value: p["id"],
                                  groupValue: _validationGroup[index]
                                      ["groupValue"],
                                  onChanged: (val) {
                                    if(p["preco"] != "0.00"){
                                      validateGroup(p["id"], "radio", c["id"], price: p["preco"]);
                                    }else{
                                      validateGroup(p["id"], "radio", c["id"]);
                                    }
                                  });
                            } else {

                              if (c["exibirQuantidade"] == true) {


                                List ListqtdAdd = _validationGroup[index]["groupValue"];
                                int qtd = 0;
                                for (int b = 0; b < ListqtdAdd.length; b++) {
                                  if (ListqtdAdd[b]["id"] == p["id"]) {
                                    qtd = ListqtdAdd[b]["qtd"];
                                    break;
                                  }
                                }

                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: descriptionProduct,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: submitButton("-", () {
                                        if(qtd > 0) {
                                          qtd = qtd - 1;

                                          if(p["preco"] != "0.00"){
                                            validateGroup(p["id"], "checkbox", c["id"], qtd: qtd, price: p["preco"], qtdIncrement: false);
                                          }else{
                                            validateGroup(p["id"], "checkbox", c["id"], qtd: qtd, qtdIncrement: false);
                                          }

                                          setState(() {
                                            _maxItems = _maxItems - 1;
                                          });
                                        }
                                      },
                                          colorText: Color(0xfff76636),
                                          bgColor: Color(0xffffffff),
                                          colorBorder: Color(0xfff76636),
                                          fontSize: 20),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          qtd.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff888888)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: submitButton("+", () {
                                          if(c["maximo"] == 0) {
                                            qtd = qtd + 1;

                                            if(p["price"] != "0.00"){
                                              validateGroup(p["id"], "checkbox", c["id"], qtd: qtd, price: p["preco"]);
                                            }else{
                                              validateGroup(p["id"], "checkbox", c["id"], qtd: qtd);
                                            }
                                          }else{

                                            if(_maxItems < c["maximo"]){

                                                qtd = qtd + 1;
                                                if(p["price"] != "0.00"){
                                                  validateGroup(p["id"], "checkbox", c["id"], qtd: qtd, price: p["preco"]);
                                                }else{
                                                  validateGroup(p["id"], "checkbox", c["id"], qtd: qtd);
                                                }
                                                setState(() {
                                                  _maxItems = _maxItems + 1;
                                                });
                                            }else{
                                              print("Limite maximo atingido!");
                                            }
                                          }

                                      },
                                          colorText: Color(0xfff76636),
                                          bgColor: Color(0xffffffff),
                                          colorBorder: Color(0xfff76636),
                                          fontSize: 20),
                                    ),
                                  ],
                                );
                              } else {
                                List checkboxValue = _validationGroup[index]["groupValue"];
                                bool isChecked = false;
                                for (int b = 0; b < checkboxValue.length; b++) {
                                  if (checkboxValue[b]["id"] == p["id"]) {
                                    isChecked = true;
                                    break;
                                  }
                                }

                                return CheckboxListTile(
                                    activeColor: Color(0xfff76636),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: descriptionProduct,
                                    ),
                                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                                    value: isChecked,
                                    onChanged: (val) {

                                      if(val == true) {
                                        if(c["maximo"] != null && c["maximo"] > 0) {

                                          if(_maxItems < c["maximo"]){

                                            if(p["price"] != "0.00"){
                                              validateGroup(p["id"], "checkbox", c["id"], price: p["preco"]);
                                            }else{
                                              validateGroup(p["id"], "checkbox", c["id"]);
                                            }
                                            setState(() {
                                              _maxItems = _maxItems + 1;
                                            });
                                          }

                                        }else{
                                          if(p["price"] != "0.00"){
                                            validateGroup(p["id"], "checkbox", c["id"], price: p["preco"]);
                                          }else{
                                            validateGroup(p["id"], "checkbox", c["id"]);
                                          }
                                        }
                                      }else{

                                        if(p["price"] != "0.00"){
                                          validateGroup(p["id"], "checkbox", c["id"], qtd:0, price: p["preco"]);
                                        }else{
                                          validateGroup(p["id"], "checkbox", c["id"], qtd: 0);
                                        }
                                        setState(() {
                                          _maxItems = _maxItems - 1;
                                        });
                                      }
                                    });
                              }
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              height: 20,
            ),
            _product.discount > 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "R\$ " + _precoPromocional.replaceAll('.', ','),
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff888888),
                          decoration: TextDecoration.lineThrough),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "R\$ " +_precoProduto.replaceAll('.', ','),
                style: TextStyle(
                    fontSize: 28,
                    color: Color(0xff40cf43),
                    fontWeight: FontWeight.bold),
              ),
            ),
            _messageErrorQtd != ""
                ? Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      _messageErrorQtd,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff76636)),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: submitButton("-", () {
                      _lessQtd();
                    },
                        colorText: Color(0xfff76636),
                        bgColor: Color(0xffffffff),
                        colorBorder: Color(0xfff76636),
                        fontSize: 24),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        _qtd.toString(),
                        style:
                            TextStyle(fontSize: 28, color: Color(0xff888888)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: submitButton("+", () {
                      _moreQtd();
                    },
                        colorText: Color(0xfff76636),
                        bgColor: Color(0xffffffff),
                        colorBorder: Color(0xfff76636),
                        fontSize: 24),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: _canBuy == true
                            ? Color(0xff40cf43)
                            : Color(0xff888888),
                      ),
                      onPressed: _canBuy == true
                          ? () {
                              print('Clicou em comprar');
                            }
                          : null,
                      label: Text(
                          _showBuyText == true ? "Comprar" : "Indisponível",
                          style: TextStyle(
                              fontSize: 22,
                              color: _canBuy == true
                                  ? Color(0xff40cf43)
                                  : Color(0xff888888))),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 57)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(
                                  color: _canBuy == true
                                      ? Color(0xff40cf43)
                                      : Color(0xff888888))),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
