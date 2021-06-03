import 'dart:async';
import 'dart:io';

import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:behind_lens/View/Common/AppBarCommon.dart';
import 'package:behind_lens/View/Common/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:behind_lens/View/Functions/ImageCropperFunction.dart';

class ProfileConfig extends StatefulWidget {
  @override
  _ProfileConfigState createState() => _ProfileConfigState();
}

class _ProfileConfigState extends State<ProfileConfig> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerDataNasc = TextEditingController();
  TextEditingController _controllerProfissao = TextEditingController();

  String _infoUpdate = '';
  bool _loadingData = false;
  List<String> _itensMenu = [
    "Galeria",
    "Camera"
  ];
  Map<String, dynamic> _myUser;
  File _image;
  final _picker = ImagePicker();
  var _pickedFile;
  String _imageProfileDefault = "assets/user-profile-no-picture.png";
  String _imageProfile = null;
  bool _progresssUpload = false;


  _initUpdate() async {
    _infoUpdate = 'Atualizando...';
    String name = _controllerNome.text;
    String email = _controllerEmail.text;
    String description = _controllerDescricao.text;
    String profession = _controllerProfissao.text;
    String birthDate = _controllerDataNasc.text;

    Users user = Users(name.toLowerCase(), email);
    user.description = description;
    user.profession = profession;
    user.birthDate = birthDate;

    UserController userController = UserController();

    String r = await userController.updateUser(user);

    setState(() {
      _infoUpdate = r;
    });

  }

  _loadingInfoUser() async {
    Map r = await UserController.loadingInfoProfile();
    if(r != null) {
      setState(() {

        _controllerNome.text = r['name'];
        _controllerEmail.text = r['email'];
        _controllerDataNasc.text = r['birthDate'].toString();
        if(r['description'] != null){
          _controllerDescricao.text = r['description'];
        }
        if(r['profileImage'] != null){
          _imageProfile = r['profileImage'];
        }
        _myUser = r;
        _loadingData = true;
      });
    }else{
      setState(() {
        _infoUpdate = "Erro ao recuperar dados do usuario";
      });
    }

  }


  Future _choseOriginImage(String choseItem) async {
      if(choseItem == "Galeria"){
        _pickedFile = await _picker.getImage(source: ImageSource.gallery);
      }else{
        _pickedFile = await _picker.getImage(source: ImageSource.camera);
      }


      File cropped;

      if (_pickedFile != null) {
        // Remove crop attribute if we don't want to resize the image
        cropped = await imageCropperFunction(_pickedFile, quality: 10);
      }else{
        cropped = null;
      }

      setState(() {
        if(cropped != null){
          _image = File(cropped.path);
        }else{
          print("Nenhuma imagem selecionada!");
        }
      });



      if(_image != null) {
         UserController userController = UserController();
         await userController.changeImageProfile(this._myUser['id'], this._image);
         setState(() {
           _progresssUpload = true;
         });

         Timer.periodic(new Duration(milliseconds: 200), (timer) async {
           if(userController.snapshot != null){
             String url = await userController.snapshot.ref.getDownloadURL();
             setState(() {
               _progresssUpload = false;
               _imageProfile = url;
             });

             timer.cancel();
           }

         });
      }
  }

  @override
  void initState() {
    super.initState();
    _loadingInfoUser();
  }

  @override
  Widget build(BuildContext context) {

    double halfLarg = (MediaQuery.of(context).size.width / 100) * 40;

    var borderDefault = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.white,
          width: 2
      ),
    );

    if(_loadingData == false){
      return LoadingPage();
    }else {
      return Scaffold(
        backgroundColor: Color(0xff222222),
        appBar: appBarCommon(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Configurações de Perfil",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
                    width: halfLarg,
                    height: halfLarg,
                    child: Container(),
                    //Image.asset(user.photo),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(halfLarg),
                      border: Border.all(color: Color(0xfffe386b), width: 4),
                      image: DecorationImage(
                          image: _imageProfile == null
                          ? AssetImage(_imageProfileDefault)
                          : NetworkImage(_imageProfile),
                          fit: BoxFit.contain
                      ),
                    ),
                  ),
                ),
              ),
              _progresssUpload != false
              ? Padding(padding: EdgeInsets.only(top: 20), child: Center(child: CircularProgressIndicator() ,),)
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
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 30),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _controllerNome,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "Nome:",
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
                  keyboardType: TextInputType.emailAddress,
                  controller: _controllerEmail,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "E-mail:",
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
                  controller: _controllerProfissao,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "profissão: ",
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
                  controller: _controllerDescricao,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "Descrição:",
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
              GestureDetector(
                onTap: () async {
                  String datatime = DateTime.now().toString();
                  List arrDatatime = datatime.split(" ");
                  List arrData = arrDatatime[0].split('-');
                  int year = int.parse(arrData[0]);
                  int lastData = year - 17;

                  int initialYear, month, day;
                  if (_controllerDataNasc.text.isEmpty) {
                    initialYear = year - 17;
                    month = 1;
                    day = 1;
                  } else {
                    String dataField = _controllerDataNasc.text;
                    List arrDataField = dataField.split("/");
                    initialYear = int.parse(arrDataField[2]);
                    month = int.parse(arrDataField[1]);
                    day = int.parse(arrDataField[0]);
                  }

                  final dataSelecionada = await showDatePicker(
                      context: context,
                      initialDate: DateTime(initialYear, month, day),
                      firstDate: DateTime(1959),
                      lastDate: DateTime(lastData, 12, 31),
                      builder: (_, child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      }
                  );

                  if (dataSelecionada != null) {
                    setState(() {
                      _controllerDataNasc.text = DateFormat('dd/MM/yyyy')
                          .format(dataSelecionada)
                          .toString();
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    controller: _controllerDataNasc,
                    enabled: false,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      hintText: "Data de nascimento: ",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: borderDefault,
                      focusedBorder: borderDefault,
                      disabledBorder: borderDefault,
                      border: borderDefault,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _initUpdate();
                },
                child: Text("Salvar alterções",
                    style: TextStyle(color: Color(0xfffe386b), fontSize: 18)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.fromLTRB(30, 20, 30, 20)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff222222)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
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
}
