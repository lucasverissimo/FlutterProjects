import 'package:flutter/material.dart';

Widget textField(TextEditingController controller, String placeholderText,
    { bool isPassword = false, bool readOnly = false, TextInputType keyboardType = TextInputType.text }
    ){

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
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: placeholderText,
        labelStyle: TextStyle(
          color: readOnly == false ? Colors.black : Color(0xff888888)
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
      readOnly: readOnly,
      style: TextStyle(
        color: readOnly == false ? Colors.black : Color(0xff888888)
      ),
    ),
  );
}