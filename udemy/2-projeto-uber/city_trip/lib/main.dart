import 'package:city_trip/telas/Home.dart';
import 'package:city_trip/telas/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'Rotas.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xffe51b23),
  accentColor: Color(0xff888888),
  iconTheme: IconThemeData(
    color: Color(0xffe51b23)
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: Color(0xffcccccc),
    iconTheme: IconThemeData(
        color: Color(0xffe51b23)
    ),
  )
);

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      //home: Home(),
      theme: temaPadrao,
      initialRoute: "/",
      onGenerateRoute: Rotas.gerarRotas,

    ),
    
  );
}