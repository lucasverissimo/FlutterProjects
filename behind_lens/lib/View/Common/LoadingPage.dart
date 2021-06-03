import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222222),
      body: Center(
        child: Container(
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
