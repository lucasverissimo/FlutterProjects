import 'package:flutter/material.dart';
import 'package:minhas_viagens/SplashScreen.dart';

import 'Home.dart';

void main(){
  runApp(
    MaterialApp(
      title: "Minhas viagens",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}