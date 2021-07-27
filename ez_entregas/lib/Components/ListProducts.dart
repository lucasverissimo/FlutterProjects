import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_entregas/Components/ProductCategoryVertical.dart';
import 'package:ez_entregas/Components/ProductCategoryHorizontal.dart';

Widget listProducts(String idCategory, BuildContext context, {typeList = 'vertical'}){



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
                    child: productCategoryVertical('id', context),
                  );
                }else
                if(typeList == 'horizontal'){
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Container(
                      height: 400,
                      child: productCategoryHorizontal('id', context),
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