import 'package:flutter/material.dart';

Widget submitButton(String label, Function submit, {
  Color colorText = const Color(0xff40cf43), Color colorBorder = const Color(0xff40cf43) ,Color bgColor = const Color(0xffffffff),
}){

  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 15),
    child: ElevatedButton(
      child: Text(label, style: TextStyle(fontSize: 18,color: colorText)),
      onPressed: ()=>submit(),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 15, bottom: 15)),
        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 40)),
        backgroundColor: MaterialStateProperty.all<Color>(bgColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(color: colorBorder)
          ),
        ),
        elevation: MaterialStateProperty.all<double>(0),
      ),
    ),
  );
}