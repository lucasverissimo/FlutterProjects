import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/ProductCategoryVertical.dart';
import 'package:ez_entregas/Components/ProductCategoryHorizontal.dart';

Widget listProducts(String idCategory, BuildContext context, {typeList = 'vertical'}){



  Map<String, dynamic> productMap = {
    "categoria": "ecnGoydHzXmpy1RTxPEe",
    "imagem": "https://firebasestorage.googleapis.com/v0/b/ez-entregas.appspot.com/o/produtos%2FZ4YAFrPC1Yf1ppDMhPKT.jpg?alt=media&token=1d49dbc0-a56c-4ab1-a9f4-06637bdf7ea1",
    "nome": "Lasanha",
    "qtdEstoque": 0,
    "categoriasComplementar": [
      "FFWCiWBvCKpx5dLG9XkW",
      "ZcFpbMdjzY84So0aHjfh"
    ],
    "preco": "19.90",
    "id": "Z4YAFrPC1Yf1ppDMhPKT",
    "exibirProduto": true,
    "nomeImagem": "Z4YAFrPC1Yf1ppDMhPKT.jpg",
    "desconto": 50,
    "descricao": "Lasanha de carne moida com presunto.",
    "possuiEstoque": false
  };

  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Promoções do dia!".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Color(0xff555555),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
            constraints: typeList == 'vertical' ? BoxConstraints(
              maxHeight: double.infinity,
            )
            : BoxConstraints(
              minHeight: 400,
              maxHeight: 450,
            ),
          child: ListView.builder(
              itemCount: 5,
              shrinkWrap: typeList == 'vertical' ? true : false,
              physics: typeList == 'vertical' ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
              scrollDirection: typeList == 'vertical' ? Axis.vertical : Axis.horizontal,
              itemBuilder: (BuildContext context, int index){

                if(typeList == 'vertical') {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == 4 ? 0 : 10, top: 20),
                    child: productCategoryVertical(productMap, context),
                  );
                }else
                if(typeList == 'horizontal'){
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Container(
                      height: 400,
                      child: productCategoryHorizontal(productMap, context),
                    ),
                  );
                }else{
                  return Container();
                }

              }
          ),
        )
      ],
    ),
  );

}