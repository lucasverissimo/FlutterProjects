import 'package:flutter/material.dart';

Widget iconButton(String label, Function submit, Icon icon,{
  Color colorText = const Color(0xff40cf43), Color colorBorder = const Color(0xff40cf43), Color bgColor = const Color(0xffffffff),
  Color colorsubText = const Color(0xff888888),
  double widthBorder = 0,  String description = '',
}){

  return Padding(
    padding: EdgeInsets.only(top: 0, bottom: 0),
    child: Column(
      children: [
        ElevatedButton.icon(
          icon: icon,
          label: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(label, style: TextStyle(fontSize: 18,color: colorText), textAlign: TextAlign.left,),
              ),
              description != ''
                  ? Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(description, style: TextStyle(color: colorsubText, fontSize: 14, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
                  )
                  : Container(),
            ],
          ),
          onPressed: ()=>submit(),
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 15, bottom: 15)),
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 40)),
            backgroundColor: MaterialStateProperty.all<Color>(bgColor),
            alignment: Alignment.centerLeft,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: colorBorder, width: widthBorder),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0),
          ),
        ),
        Divider(),
      ],
    ),
  );
}