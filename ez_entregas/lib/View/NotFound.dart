import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:ez_entregas/Components/DefaultButtonSubmit.dart';
import 'package:flutter/material.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key key}) : super(key: key);

  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault("Ez Entregas Delivery!"),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Página não encontrada!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff000000)),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Não conseguimos localizar\na página ou serviço!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                  textAlign: TextAlign.center,
                ),
              ),
              submitButton(
                  "Voltar para home",
                  (){
                    Navigator.pushReplacementNamed(context, "/");
                  },
                colorText: Color(0xfff76636),
                bgColor: Color(0xffffffff),
                colorBorder: Color(0xfff76636),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
