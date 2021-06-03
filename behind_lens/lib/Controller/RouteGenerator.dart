import 'package:behind_lens/View/Screens/AccessConfig.dart';
import 'package:behind_lens/View/Screens/Home.dart';
import 'package:behind_lens/View/Screens/Post.dart';
import 'package:behind_lens/View/Screens/Profile.dart';
import 'package:behind_lens/View/Screens/ProfileConfig.dart';
import 'package:behind_lens/View/Screens/AddNewPost.dart';
import 'package:flutter/material.dart';

import 'package:behind_lens/View/Screens/RegisterUser.dart';
import 'package:behind_lens/View/Screens/Login.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/registerUser":
        return MaterialPageRoute(builder: (_) => RegisterUser());
        break;
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case "/profile":
        return MaterialPageRoute(builder: (_) => Profile(id: args,));
        break;
      case "/post":
        return MaterialPageRoute(builder: (_) => Post(args));
        break;
      case "/profileConfig":
        return MaterialPageRoute(builder: (_) => ProfileConfig());
      case "/accessConfig":
        return MaterialPageRoute(builder: (_) => AccessConfig());
        break;
      case "/addNewPost":
        return MaterialPageRoute(builder: (_) => AddNewPost());
        break;
      default:
        _errorRoute();
        break;
    }

  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }

}