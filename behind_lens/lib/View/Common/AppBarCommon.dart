import 'package:flutter/material.dart';


Widget appBarCommon(BuildContext context, { Widget bottomAppBar}){
 return AppBar(
    elevation: 10,
    backgroundColor: Color(0xff444444),
    title: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      child: Image.asset("assets/logo-white-no-icon.png", width: 70,),
    ),
    actions: [
      IconButton(
          icon: Icon(Icons.search_outlined),
          onPressed: (){}
      ),
      IconButton(
          icon: Icon(Icons.account_circle_outlined),
          onPressed: (){
            Navigator.pushNamed(context, "/profile");
          }
      ),
    ],
    bottom: bottomAppBar != null
        ? bottomAppBar
        : null,
  );
}