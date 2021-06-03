import 'dart:async';
import 'dart:io';

import 'package:behind_lens/Controller/Posts/PostsController.dart';
import 'package:behind_lens/Model/Entities/Posts.dart';
import 'package:behind_lens/View/Common/AppBarCommon.dart';
import 'package:behind_lens/View/Functions/ImageCropperFunction.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewPost extends StatefulWidget {
  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {

  TextEditingController _controllerDescription = TextEditingController();
  bool _progresssUpload = false;
  List<String> _itensMenu = [
    "Galeria",
    "Camera"
  ];
  final _picker = ImagePicker();
  var _pickedFile;
  Posts _newPost = Posts();
  String _infoCad = "";

  Future _choseOriginImage(String choseItem) async {
    if(choseItem == "Galeria"){
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    }else{
      _pickedFile = await _picker.getImage(source: ImageSource.camera);
    }


    File cropped;

    if (_pickedFile != null) {
      // Remove crop attribute if we don't want to resize the image
      cropped = await imageCropperFunction(_pickedFile, quality: 80, width: 500, height: 500);
    }else{
      cropped = null;
    }


    if(cropped != null){
      setState(() {
         _newPost.imageFile = File(cropped.path);
      });
    }else{
      print("Nenhuma imagem selecionada!");
    }
  }

  _initPosting() async {


    if(_newPost.imageFile == null){
      setState(() {
        _infoCad = "Selecione uma imagem para publicar!";
      });
    }else{
      setState(() {
        _infoCad = "Aguarde...";
        _newPost.description = _controllerDescription.text;
      });

      PostsController postsController = PostsController();
      await postsController.addNewPost(_newPost);
      Timer.periodic(new Duration(milliseconds: 2000), (timer) async {
        if(postsController.progressUpload == "ok"){
          timer.cancel();

          setState(() {
            _infoCad = "Publicado com sucesso!";
            _newPost.description = null;
            _newPost.imageFile = null;
            _controllerDescription.text = "";
          });
         // print("ID document: "+ postsController.documentId.toString());
          Navigator.pushNamed(context, "/post", arguments: postsController.documentId);

        }else{

          setState(() {
            _infoCad = postsController.progressUpload;
          });
        }
      });
    }
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
                "Publicar nova imagem",
                style: TextStyle(color: Colors.white, fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: _controllerDescription,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  hintText: "Descrição...",
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
            Padding(padding: EdgeInsets.only(bottom: 10)),
            _progresssUpload != false
                ? Padding(padding: EdgeInsets.only(top: 0), child: Center(child: CircularProgressIndicator() ,),)
                : PopupMenuButton<String>(
              onSelected: _choseOriginImage,
              color: Color(0xff222222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                    width: 2,
                    color: Color(0xfffe386b)
                ),
              ),
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                label: Text(
                  "Alterar foto de perfil", style: TextStyle(fontSize: 18, color: Colors.white),),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.fromLTRB(10, 15, 10, 15)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff222222)),
                  shadowColor: MaterialStateProperty.all<Color>(
                      Color(0xff222222)),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              itemBuilder: (context){
                return _itensMenu.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    //child: Text(item, style: TextStyle(color: Colors.white),),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        item == "Galeria"
                            ? Icons.image
                            : Icons.camera,
                        color: Colors.white,
                      ),
                      label: Text(item, style: TextStyle(color: Colors.white, fontSize: 14),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),
                      ),
                    ),
                  );
                }).toList();
              },

            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            _newPost.imageFile == null
            ? Container()
            //: Center(child: Image.file(_newPost.imageFile, width: (MediaQuery.of(context).size.width / 100) * 90,),),
            : Container(
              width: (MediaQuery.of(context).size.width / 100) * 90,
              height: (MediaQuery.of(context).size.width / 100) * 90,
              child: Container(),
              //Image.asset(user.photo),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffffffff), width: 4),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                    image: FileImage(_newPost.imageFile),
                    fit: BoxFit.contain
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            ElevatedButton(
              onPressed: (){
                _initPosting();
              },
              child: Text("Publicar", style: TextStyle(color: Color(0xfffe386b), fontSize: 18)),
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
              padding: EdgeInsets.only(bottom: 30, top: 30),
              child: Text(
                _infoCad,
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
