import 'package:flutter/material.dart';

Widget textField(TextEditingController controller, String placeholderText, { bool isPassword = false }){

  InputBorder borderDefault = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
        width: 1,
        color: Color(0xffeeeeee)
    ),
  );

  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 15),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: placeholderText,
        labelStyle: TextStyle(
          color: Colors.black
        ),
        border: borderDefault,
        enabledBorder: borderDefault,
        disabledBorder: borderDefault,
        focusedBorder: borderDefault,
        filled: true,
        fillColor: Color(0xffefefef),
      ),
      obscureText: isPassword,
      obscuringCharacter: '*',
    ),
  );
}