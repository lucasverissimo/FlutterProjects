import 'dart:io';

import 'package:behind_lens/View/Common/ItemPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();

  Map<String, dynamic> dataPost;
  Post(this.dataPost);

}

class _PostState extends State<Post> {

  TextEditingController _controllerComentario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color(0xff444444),
        title: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 0),
          child: Image.asset("assets/logo-white-no-icon.png", width: 70,),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: (){}
          ),
          IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: (){}
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           // ItemPost(-1, {}),
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: TextField(
                          controller: _controllerComentario,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                              hintText: "Digite uma mensagem...",
                              filled: true, // ativa ou desativa cor de fundo
                              fillColor: Colors.transparent, // cor de fundo, so funciona se filled estiver true
                              hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                  color: Color(0xfffe386b),
                                  width: 1
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                    color: Color(0xfffe386b),
                                    width: 1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                    color: Color(0xfffe386b),
                                    width: 1
                                ),
                              )
                              // prefixIcon: IconButton(icon: Icon(Icons.camera_alt, color: Color(0xff075e54), ), onPressed: (){},)
                          ),
                        ),
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton( // este botão é padrão no IOS
                        child: Text("Enviar", style: TextStyle(fontSize: 14, color: Color(0xfffe386b)),),
                        onPressed: (){}
                    )
                        : FloatingActionButton(
                      onPressed: (){},
                      backgroundColor: Color(0xff075e54),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      mini: true,
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: ListTile(
                      title: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/profile");
                        },
                        child: Text("Gabrielle Aplin", style: TextStyle(color: Colors.white, fontSize: 22),),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec orci nunc, viverra nec lobortis eget, tempor id mi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.",
                            style: TextStyle(color: Color(0xffaaaaaa), fontSize: 16),
                            textAlign: TextAlign.justify
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      leading: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/profile");
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/user-example-image.jpg"),
                          radius: 30,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.white,),
                        onPressed: (){
                        },
                      ),

                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
