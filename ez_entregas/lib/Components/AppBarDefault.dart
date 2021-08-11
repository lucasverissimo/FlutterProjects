import 'package:flutter/material.dart';

Widget appBarDefault(String title, {bool showLeading = true}){
  return AppBar(
    automaticallyImplyLeading: showLeading,
    title: Text(title, style: TextStyle(color: Color(0xfff76636)),),
    actions: [
      IconButton(
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: (){}
      ),
    ],
  );
}