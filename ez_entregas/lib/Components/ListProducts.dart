import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/ProductCategory.dart';

Widget listProducts(String idCategory, BuildContext context){



  return Container(
    padding: EdgeInsets.only(top: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25),
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
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            print(index == 4);
            return Padding(
              padding: EdgeInsets.only(bottom: index == 4 ? 0 : 10, top: 20),
              child: productCategory('id', context),
            );
          }
        )
      ],
    ),
  );

}