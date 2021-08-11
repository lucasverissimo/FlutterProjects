import 'package:ez_entregas/View/Home.dart';
import 'package:ez_entregas/View/NotFound.dart';
import 'package:ez_entregas/View/Category.dart';
import 'package:ez_entregas/View/Product.dart';
import 'package:ez_entregas/View/UserRegister.dart';

import 'package:flutter/material.dart';

class Routes{

  static Route<dynamic> generateRoutes(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case "/userRegister":
        return MaterialPageRoute(builder: (_) => UserRegister(isBuy: args,));
        break;
      case "/category":
        return MaterialPageRoute(builder: (_) => Category(args));
        break;
      case "/product":
        return MaterialPageRoute(builder: (_) => Product(args));
        break;

      default:
        return MaterialPageRoute(builder: (_) => NotFound());
        break;
    }
  }

}