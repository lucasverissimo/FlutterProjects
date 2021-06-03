import 'package:behind_lens/Controller/RouteGenerator.dart';
import 'package:behind_lens/View/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'View/Screens/Home.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    //home: Home(),
    // initialRoute: "/home",
    onGenerateRoute: RouteGenerator.generateRoute,
    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate
    ],
    supportedLocales: [
      const Locale('pt', 'BR')
    ],
  ));
}