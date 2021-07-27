import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget productCategoryVertical(String idCategory, BuildContext context){

  double widthImage = (MediaQuery.of(context).size.width / 100) * 10;
  double widthInfos = (MediaQuery.of(context).size.width / 100) * 68;


  String nomeProduto = 'Hamburguer com molho Chik Fill';
  String descricaoProduto = 'Hamburguer 250g, tomate, alface, molho chik fill, bacon e molho a moda da casa.';

  return Flex(
    direction: Axis.horizontal,
    children: [
      Expanded(
        flex: 3,
        child:  ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child:  Image.asset('assets/images/produto-exemplo.jpg'),
        ),
      ),
      SizedBox(height: 10, width: 10,),
      Expanded(
        flex: 4,
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
                  style: TextStyle(fontSize: 20, color: Color(0xff555555), fontWeight: FontWeight.bold),
                ),
              ),
           /*   Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Text(descricaoProduto),
              ),*/
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
                  print("Clicou em comprar");
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
  );
}