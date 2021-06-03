import 'dart:async';

import 'package:flutter/material.dart';

import 'Home.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home())
      );
    });
  }


  @override
  Widget build(BuildContext context) {

    double widthImg;
    double heightImg;
    double widthDisplay;
    if(MediaQuery.of(context).size.width > 768){
      widthImg = (MediaQuery.of(context).size.width / 100) * 30;
      heightImg = (MediaQuery.of(context).size.width / 100) * 30;
      widthDisplay = 1024;
    }else{
      widthImg = (MediaQuery.of(context).size.width / 100) * 50;
      heightImg = (MediaQuery.of(context).size.width / 100) * 50;
      widthDisplay = MediaQuery.of(context).size.width;
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg-splash-screen.png"),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Container(
            width: widthDisplay,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: widthImg,
                  height: heightImg,
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
