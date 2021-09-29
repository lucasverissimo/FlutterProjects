import 'package:ez_entregas/View/Home.dart';
import 'package:ez_entregas/View/NotFound.dart';
import 'package:ez_entregas/View/Category.dart';
import 'package:ez_entregas/View/Product.dart';
import 'package:ez_entregas/View/UserRegister.dart';
import 'package:ez_entregas/View/UserAccount.dart';
import 'package:ez_entregas/View/AddressList.dart';
import 'package:ez_entregas/View/OrdersList.dart';

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
      case "/userAccount":
        return MaterialPageRoute(builder: (_) => UserAccoount(args));
        break;
      case "/addressList":
        return MaterialPageRoute(builder: (_) => AddressList());
        break;
      case "/ordersList":
        return MaterialPageRoute(builder: (_) => OrdersList());
        break;

      default:
        return MaterialPageRoute(builder: (_) => NotFound());
        break;
    }
  }

}