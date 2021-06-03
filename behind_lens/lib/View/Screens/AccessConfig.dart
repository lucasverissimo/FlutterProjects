import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:behind_lens/View/Common/AppBarCommon.dart';
import 'package:flutter/material.dart';

class AccessConfig extends StatefulWidget {
  @override
  _AccessConfigState createState() => _AccessConfigState();
}

class _AccessConfigState extends State<AccessConfig> {

  TextEditingController _controllerPass = TextEditingController();
  TextEditingController _controllerConfirmPass = TextEditingController();
  String _infoUpdate = "";

  _initChangePassword() async {
    String pass = _controllerPass.text;
    String confirmPass = _controllerConfirmPass.text;
    String r = "";

    if(pass.length < 8){
      r = "A senha deve possuir ao menos 8 digitos.";
    }else
    if(pass != confirmPass){
      r = "As senhas nao conferem!";
    }else{
      UserController userController = UserController();
      r = await userController.changePassword(pass);
    }


    setState(() {
      _infoUpdate = r;
    });
  }

  @override
  Widget build(BuildContext context) {

    var borderDefault = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.white,
          width: 2
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: appBarCommon(context),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "Configurações de Acesso",
                style: TextStyle(color: Colors.white, fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _controllerPass,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  hintText: "Nova senha:",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: borderDefault,
                  focusedBorder: borderDefault,
                  border: borderDefault,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _controllerConfirmPass,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  hintText: "Confirmar nova senha:",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: borderDefault,
                  focusedBorder: borderDefault,
                  border: borderDefault,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                _initChangePassword();
              },
              child: Text("Salvar alterções", style: TextStyle(color: Color(0xfffe386b), fontSize: 18)),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(30, 20, 30, 20)),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222222)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      width: 2,
                      color: Color(0xfffe386b)
                  ),
                )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: (){

                },
                child: Text("Desejo desativar minha conta", style: TextStyle(color: Color(0xfffe386b), fontSize: 18)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(30, 20, 30, 20)),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffffff)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        width: 2,
                        color: Color(0xffffffff)
                    ),
                  )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30, top: 30),
              child: Text(
                _infoUpdate,
                style: TextStyle(color: Colors.yellow, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
