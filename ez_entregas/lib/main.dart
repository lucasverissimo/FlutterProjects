import 'package:flutter/material.dart';
import 'package:ez_entregas/View/Home.dart';
import 'package:ez_entregas/Services/Routes.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xfff76636),
    accentColor: Color(0xffffffff),
    iconTheme: IconThemeData(
        color: Color(0xff40cf43)
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: null,
      iconTheme: IconThemeData(
          color: Color(0xfff76636)
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
);

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: temaPadrao,
      initialRoute: "/",
      onGenerateRoute: Routes.generateRoutes,
    ),
  );
}