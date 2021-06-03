import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:behind_lens/View/Functions/CapExtension.dart';

class ItemPost extends StatefulWidget {
  @override
  _ItemPostState createState() => _ItemPostState();

  int index;
  Map<String, dynamic> infoPost;
  String docUser;
  Map<String, dynamic> infoUser;

  ItemPost(this.index, this.infoPost, this.docUser, {this.infoUser});

}

class _ItemPostState extends State<ItemPost> {

  Map<String, dynamic> _dataPost = {};
  bool _loadingProfile = false;
  Map<String, dynamic> _infoUser;
  List<String> _itensMenu = [];



  _loadInfoUser() async {

    if(widget.infoUser == null) {
      Map<String, dynamic> r = await UserController.loadingInfoProfile(id: widget.docUser);
      setState(() {
        _infoUser = r;
        _loadingProfile = true;
        _itensMenu.add("Denunciar");
      });
    }else{
      setState(() {
        _infoUser = widget.infoUser;
        _loadingProfile = true;
        _itensMenu.add("Excluir");
      });
    }

  }

  _formatarData(dynamic data, {bool timestampfirebase = false}){
    String d;
    if(timestampfirebase == true){
      Timestamp dateTime = data;
      d = dateTime.toDate().toString();
    }else{
      d = data;
    }

    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("d/MM/y - H:mm");
    //var formatador = DateFormat.yMMMMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(d);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _choseOriginMenuButtonPost(String option){

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataPost = widget.infoPost;
    });
    _loadInfoUser();
  }

  @override
  Widget build(BuildContext context) {

    int index = widget.index;


      if(_loadingProfile == false){
        return Container();
      }else {
        String name = _infoUser['name'];
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff444444),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(name.capitalizeFirstofEach,
                    style: TextStyle(color: Colors.white, fontSize: 22),),
                  subtitle: Text(_infoUser['profession'].length > 0 ? _infoUser['profession'] : '',
                    style: TextStyle(color: Color(0xff888888), fontSize: 14),),
                  contentPadding: EdgeInsets.all(0),
                  onTap: () {
                    Navigator.pushNamed(context, "/profile",
                        arguments: _infoUser['id']);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        _infoUser['profileImage']),
                    radius: 30,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: _choseOriginMenuButtonPost,
                    color: Color(0xff222222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                          width: 2,
                          color: Color(0xfffe386b)
                      ),
                    ),
                    child: Icon(Icons.more_vert, color: Colors.white,),
                    itemBuilder: (context){
                      return _itensMenu.map((String item){
                        return PopupMenuItem<String>(
                          value: item,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              item == "Excluir"
                                  ? Icons.delete_outlined
                                  : Icons.dangerous,
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
                ),
                _dataPost['description']
                    .toString()
                    .length > 1
                    ? Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    _dataPost['description'].toString(),
                    style: TextStyle(color: Color(0xffffffff), fontSize: 13,),
                    textAlign: TextAlign.center,
                  ),
                )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    if (widget.index != -1) {
                      Map<String, dynamic> dataPost = {
                        'userInfo': _infoUser,
                        'postId': _dataPost['id'],
                      };
                      Navigator.pushNamed(
                          context, "/post", arguments: dataPost);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff333333),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.all(5),
                    // child: Image.asset("assets/example-image-post.jpg", width: MediaQuery.of(context).size.width,),
                    child: /*FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: _dataPost['image'],
                  width: MediaQuery.of(context).size.width,

                ),*/
                    Image(
                      image: NetworkImage(_dataPost['image']),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    widget.index == -1
                        ? Container()
                        : IconButton(
                        icon: Icon(Icons.check,
                          color: index % 2 == 0 ? Color(0xfffe386b) : Colors
                              .white,),
                        onPressed: () {}
                    ),
                    widget.index == -1
                        ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(_formatarData(
                          _dataPost['datePost'], timestampfirebase: true),
                        style: TextStyle(
                            color: Color(0xff888888), fontSize: 14),),
                    )
                        : Text(_formatarData(
                        _dataPost['datePost'], timestampfirebase: true),
                      style: TextStyle(
                          color: Color(0xff888888), fontSize: 14),),
                    widget.index == -1
                        ? Container()
                        : IconButton(
                        icon: Icon(
                            Icons.insert_comment_outlined, color: Colors.white),
                        onPressed: () {}
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }

  }
}
