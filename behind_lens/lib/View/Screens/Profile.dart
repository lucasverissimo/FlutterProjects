import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:behind_lens/View/Common/AppBarCommon.dart';
import 'package:behind_lens/View/Common/ItemPost.dart';
import 'package:behind_lens/View/Common/LoadingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behind_lens/View/Functions/CapExtension.dart';

// how to use capitalize
//final helloWorld = 'hello world'.inCaps; // 'Hello world'
//final helloWorld = 'hello world'.allInCaps; // 'HELLO WORLD'
//final helloWorldCap = 'hello world'.capitalizeFirstofEach; // 'Hello World'

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();

  String id;
  Profile({this.id});

}

class _ProfileState extends State<Profile> {

  Map<String, dynamic> _users;
  bool _loading = true;
  bool _loadingListItens = false;
  bool _listDone = false;
  int _initialNumberPosts = 10;
  List _posts;
  ScrollController _scrollController = ScrollController();
  String _returnConsultList = "";

  _initProfile() async {
    Map<String, dynamic> r;
    if(widget.id == null){
      r = await UserController.loadingInfoProfile();
    }else{
      r = await UserController.loadingInfoProfile(id: widget.id);
    }


    setState(() {
      _users = r;
      _loading = false;
    });

    // print(_users.toString());
    await _readingPosts(_users['id'], _initialNumberPosts);
  }

  _readingPosts(String doc, int qtd) async {
    UserController userController = UserController();
    List r;
    if(_returnConsultList.length < 1) {
      r = await userController.readingPosts(doc, qtd);
      setState(() {
        _posts = r;
        _loadingListItens = false;

        if(r.length < _initialNumberPosts) {
          _listDone = true;
          _returnConsultList = "Fim das postagens";
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _initProfile();


  }

  @override
  Widget build(BuildContext context) {

    if(_loading == true){
      return LoadingPage();
    }else {

      String name = _users['name'];

      double halfLarg = (MediaQuery.of(context).size.width / 100) * 40;
      Widget buttonFollow;

      if(widget.id != null || widget.id == _users['id']){
        // 0xfffe386b
        String textBtn;
        bool follow = false;
        Color colorTextBtn;
        Color colorBorderBtn;

        if(follow == false){
          colorTextBtn = Color(0xfffe386b);
          colorBorderBtn = Color(0xfffe386b);
          textBtn = "Seguir";
        }else{
          textBtn = "Seguindo";
          colorTextBtn = Color(0xffffffff);
          colorBorderBtn = Color(0xffffffff);
        }

        buttonFollow = Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: ElevatedButton(
            onPressed: () {
            },
            child: Text(textBtn,
                style: TextStyle(color: colorTextBtn, fontSize: 18)),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.fromLTRB(60, 20, 60, 20)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xff222222)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        width: 2,
                        color: colorBorderBtn
                    ),
                  )),
            ),
          ),
        );
      }else{
        buttonFollow = Container();
      }

      return Scaffold(
        backgroundColor: Color(0xff222222),
        appBar: appBarCommon(context),
        body: NotificationListener(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
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
                            image: _users['profileImage'] == null
                                ? AssetImage("assets/user-profile-no-picture.png")
                                : NetworkImage(_users['profileImage']),
                            fit: BoxFit.contain
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  name.capitalizeFirstofEach,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  _users['profession'] == null ? "" : _users['profession'],
                  style: TextStyle(color: Color(0xff888888), fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _users['numberPosts'] == null
                                ? "0"
                                :  '120',//_users['numberPosts'].toString(),
                            style: TextStyle(fontSize: 20, color: Color(
                                0xfffe386b)),),
                          Text("Postagens",
                            style: TextStyle(fontSize: 15, color: Color(
                                0xff888888)),),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _users['numberFollowers'] == null
                                ? '1.2k'
                                : _users['numberFollowers'].toString(),
                            style: TextStyle(fontSize: 20, color: Color(
                                0xfffe386b)),),
                          Text("Seguidores",
                            style: TextStyle(fontSize: 15, color: Color(
                                0xff888888)),),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 30),
                  child: Text(
                    _users['description'] == null
                        ? ""
                        : _users['description'],
                    style: TextStyle(fontSize: 16,
                        color: Color(0xff888888),
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                buttonFollow,
                // books
                /*Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xff444444),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Container(
                    height: 160.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(10, (int index) {
                        return Card(
                          color: Color(0xff222222),
                          child: Container(
                            width: 160.0,
                            height: 160.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/profile");
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/user-example-image.jpg"),
                                        radius: 50,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text("Estúdio GSM", style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.center,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ), */

                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                _posts == null
                    ? Center(child: Text("Nenhuma postagem encontrada!"),)
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return ItemPost(index, _posts[index], _users['id'], infoUser: _users,);
                    }
                ),
                _posts == null
                ? Center(child: CircularProgressIndicator(),) //Container()
                : _loadingListItens == false
                ? Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Text(_returnConsultList, style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                  )
                : Center(child: CircularProgressIndicator(),),
              ],
            ),
          ),
          onNotification: (t) {
            if (t is ScrollEndNotification) {
              if(_scrollController.position.atEdge == true){
                if(_listDone == false) {
                  setState(() {
                    _loadingListItens = true;
                    _initialNumberPosts = _initialNumberPosts + 10;
                  });

                  _readingPosts(_users['id'], _initialNumberPosts);
                }
              }
            }
          },
        )
      );
    }
  }
}
