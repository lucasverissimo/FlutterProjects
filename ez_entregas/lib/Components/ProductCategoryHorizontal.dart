import 'package:ez_entregas/Model/ProductModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget productCategoryHorizontal(Map<String, dynamic> productMap, BuildContext context){

  double widthImage = (MediaQuery.of(context).size.width / 100) * 40;
  double widthInfos = (MediaQuery.of(context).size.width / 100) * 68;


  String nomeProduto = 'Hamburguer com molho Chik Fill';
  String descricaoProduto = 'Hamburguer 250g, tomate, alface, molho chik fill, bacon e molho a moda da casa. Hamburguer 250g, tomate, alface, molho chik fill, bacon e molho a moda da casa.';

  return Container(
    height: 400,
    width: widthImage,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child:  Image.asset('assets/images/produto-exemplo.jpg', height: widthImage,),
          ),
        ),
        SizedBox(height: 10, width: 10,),
        Container(
            child: Container(
              width: widthInfos,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      nomeProduto,
                      style: TextStyle(fontSize: 18, color: Color(0xff555555), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 25),
                    height: 75,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3, // this will show dots(...) after 2 lines
                            strutStyle: StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: TextStyle(fontSize: 12, color: Color(0xff000000),),
                                text: descricaoProduto
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "R\$ 22,90",
                      style: TextStyle(fontSize: 12, color: Color(0xff888888), decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child:  Text(
                      "R\$ 19,90",
                      style: TextStyle(fontSize: 20, color: Color(0xff40cf43), fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_sharp, color: Color(0xff40cf43),),
                    onPressed: (){

                      ProductModel product = ProductModel(productMap);
                      Navigator.pushNamed(context, '/product', arguments: product);

                    },
                    label: Text("Detalhes", style: TextStyle(fontSize: 18,color: Color(0xff40cf43))),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 40)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Color(0xff40cf43))
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  )
                ],
              ),
            )
        ),


      ],
    ),
  );
}